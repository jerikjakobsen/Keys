import { UserModel } from "../../Mongo/Models/User";
import { argonHashCompare } from "../../PasswordManagement/Hash";
import { validateRequest } from "../../Middleware/ValidateRequest";
import z from "zod";
import { createUserSession } from "./CreateUserSession";

const schema = {
  bodySchema: z.object({
    email: z.email(),
    password: z.string(),
  }),
};

export const login = validateRequest(
  schema,
  async (req, res) => {
    const { email, password } = req.validatedBody;

    try {
      const user = await UserModel.findOne({ email });

      if (user) {
        const { salt, vaultLastUpdated, passHash } = user;
        const updatedAtSeconds = Math.trunc(vaultLastUpdated.getTime() / 1000);
        if (await argonHashCompare(password, salt, passHash)) {
          req.session.validatedSession.user = createUserSession(
            user._id as string,
          );
          res.setHeader("dbUpdatedAt", String(updatedAtSeconds));

          return res.status(200).json({ user_id: user._id });
        } else {
          return res.status(401).json({ Error: "Could not find user" });
        }
      } else {
        req.session.validatedSession.user = undefined;
        return res.status(401).json({ Error: "Could not find user" });
      }
    } catch (err) {
      return res
        .status(500)
        .json({ Error: "Something went wrong on our end!" });
    }
  },
  false,
);
