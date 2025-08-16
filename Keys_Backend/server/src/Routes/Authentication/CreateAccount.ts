import { UserModel } from "../../Mongo/Models/User";
import { argonHash } from "../../PasswordManagement/Hash";
import { randomBytes } from "crypto";
import { validateRequest } from "../../Middleware/ValidateRequest";
import z from "zod";
import { createUserSession } from "./CreateUserSession";

const schema = {
  bodySchema: z.object({
    email: z.email(),
    password: z.string(),
  }),
};

export const createAccount = validateRequest(
  schema,
  async (req, res) => {
    const { password, email } = req.validatedBody;

    try {
      if (await UserModel.exists({ email: email })) {
        return res.status(409).json({ message: "Email already exists" });
      }
      const salt = randomBytes(32).toString("base64");

      const user = await UserModel.create({
        email,
        passHash: await argonHash(password, salt),
        salt,
      });
      if (user) {
        req.session.validatedSession.user = createUserSession(
          user._id as string,
        );
      } else {
        return res
          .status(500)
          .json({ Error: "Something went wrong on our end!" });
      }
      return res.status(201).json({ user_id: user._id });
    } catch (err) {
      console.log(err);
      return res
        .status(500)
        .json({ Error: "Something went wrong on our end!" });
    }
  },
  false,
);
