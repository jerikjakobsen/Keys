import { Schema, model, Document } from "mongoose";

export interface User extends Document {
  email: string;
  passHash: string;
  salt: string;
  vaultLastUpdated: Date;
  vaultHash: string;
}

const UserSchema = new Schema<User>(
  {
    email: {
      type: String,
      lowercase: true,
      required: [true, "Email cannot be blank"],
      unique: true,
      match: [
        /^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/,
        "Invalid Email",
      ],
    },
    passHash: {
      type: String,
      required: [true, "Hash cannot be blank"],
    },
    salt: {
      type: String,
      required: [true, "Salt cannot be blank"],
    },
    vaultLastUpdated: {
      type: Date,
      default: (): Date => {
        return new Date(0);
      },
    },
    vaultHash: {
      type: String,
      required: false,
    },
  },
  { timestamps: true },
);

export const UserModel = model<User>("User", UserSchema);
