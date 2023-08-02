import {UserModel} from '../Database/Models/User'
import {Request, Response} from "express"
import { hash } from 'argon2'

export default async function login(req: Request, res: Response) {

    const {username, password} = req.body

    if (!username || !password) {
        res.status(400).json({"message": "Not all fields included in request"})
    }

    let hashedPassword: String = await hash(password)

    try {
        let user = await UserModel.findOne({username: username, password: hashedPassword})
        if (user) {
            return res.status(200).json({"user_id": user._id})
        }
    } catch (err) {
        return res.status(500).json({"Error": "Something went wrong on our end!"})
    }
}