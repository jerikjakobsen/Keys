import { S3Client } from "@aws-sdk/client-s3";
import { Upload } from "@aws-sdk/lib-storage";
import { Stream } from "stream";
import { UserModel } from "../../Mongo/Models/User";
import UploadMessages from "../Messages/UploadMessages";
import { createHash } from "crypto";
import { validateRequest } from "../../Middleware/ValidateRequest";
import { z } from "zod";
import { EnvironmentManager } from "../../utils/EnvironmentManager";

const schema = {
  headerSchema: z.object({
    vaultLastUpdated: z.coerce.number().int().nonnegative().default(Date.now),
  }),
  querySchema: z.object({
    overwrite: z.coerce.boolean().default(false),
  }),
};

export const updateKDBX = validateRequest(
  schema,
  async (req, res) => {
    const { id: userId } = req.session.validatedSession.user;
    let { vaultLastUpdated } = req.validatedHeaders;
    let { overwrite } = req.validatedQuery;

    let user = await UserModel.findById(userId);
    if (!user) {
      return res.status(500).json({ message: "User not found" });
    }

    const vaultLastUpdatedDate = new Date(vaultLastUpdated);

    if (user.vaultLastUpdated > vaultLastUpdatedDate && !overwrite) {
      return res.status(400).json({ message: UploadMessages.OverwriteMessage });
    }

    let hash = createHash("sha256");

    let stream = new Stream.PassThrough();
    req.pipe(stream);
    req.pipe(hash);

    const uploadParams = {
      Bucket: EnvironmentManager.vars.AWSBucket,
      Key: `${userId}`,
      Body: stream,
    };

    try {
      const uploadToS3 = new Upload({
        client: new S3Client({ region: EnvironmentManager.vars.AWSRegion }),
        params: uploadParams,
      });

      await uploadToS3.done();

      user.vaultLastUpdated = vaultLastUpdatedDate;
      user.vaultHash = hash.digest("hex");

      await user.save();

      return res.status(200).json({
        message: "Uploaded Successfully",
        currentVaultHash: user.vaultHash,
      });
    } catch (err) {
      console.error(err);
      return res
        .status(500)
        .json({ message: "Something went wrong on our end!" });
    }
  },
  true,
);
