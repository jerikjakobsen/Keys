import {Schema, model, Document} from 'mongoose'

export interface User extends Document {
    username: string;
    email: string;
    hash: string;
    salt: string;
    dbUpdatedAt: Date;
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
        required: [true, "Email cannot be blank"],
        unique: true,
        match: [/^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/, "Invalid Email"]
    },
    hash: {
        type: String,
        required: [true, "Hash cannot be blank"]
    },
    salt: {
        type: String,
        required: [true, "Salt cannot be blank"]
    },
    dbUpdatedAt: {
        type: Date,
        required: [true, "dbUpdatedAt cannot be empty"]
    }
}, {timestamps: true})

export const UserModel = model<User>('User', UserSchema)
