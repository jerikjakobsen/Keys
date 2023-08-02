import {Schema, model, Document} from 'mongoose'

export interface User extends Document {
    username: string;
    email: string;
    hash: string;
  }

const UserSchema = new Schema<User>({
    username: {
        type: String,
        lowercase: true,
        required: [true, "Username cannot be blank"],
        unique: true
    },
    email: {
        type: String,
        lowercase: true,
        required: [true, "Username cannot be blank"],
        unique: true,
        match: [/^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/, "Invalid Email"]
    },
    hash: {
        type: String,
    }
}, {timestamps: true})

export const UserModel = model<User>('UserModel', UserSchema)
