import { GetObjectCommand, S3Client } from "@aws-sdk/client-s3";
import { Readable } from "stream";
import { UserModel } from "../../Mongo/Models/User";
import { z } from "zod";
import { validateRequest } from "../../Middleware/ValidateRequest";
import { EnvironmentManager } from "../../utils/EnvironmentManager";

const schema = {
  headerSchema: z.object({
    clientVaultHash: z.string(),
  }),
};

export const getKDBX = validateRequest(
  schema,
  async (req, res) => {
    const { id: userId } = req.session.validatedSession.user;
    const { clientVaultHash } = req.validatedHeaders;

    try {
      const user = await UserModel.findById(userId);

      if (!user) {
        return res
          .status(404)
          .json({ message: "User not found", useLocal: false });
      }

      if (clientVaultHash === user.vaultHash) {
        return res.status(200).json({
          message: "Client possesses up to date vault locally",
          useLocal: true,
        });
      }

      const s3Client = new S3Client({
        region: EnvironmentManager.vars.AWSRegion,
      });
      const command = new GetObjectCommand({
        Bucket: EnvironmentManager.vars.AWSBucket,
        Key: userId,
      });
      const updatedAtSeconds = Math.trunc(
        user.vaultLastUpdated.getTime() / 1000,
      );

      const fileObject = await s3Client.send(command);
      if (fileObject.$metadata.httpStatusCode !== 200) {
        return res.status(404);
      }
      const fileStream = fileObject.Body as Readable;
      res.appendHeader("content-type", "application/octet-stream");
      res.appendHeader("dbUpdatedAt", String(updatedAtSeconds));

      fileStream.pipe(res);

      fileStream.once("end", () => {
        return res.status(200);
      });

      return res
        .status(200)
        .json({ message: "Successfully transferred vault", useLocal: false });
    } catch (err) {
      console.error(err);
      return res
        .status(500)
        .json({ message: "Something went wrong on our end!", useLocal: false });
    }
  },
  true,
);
