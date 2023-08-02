import {UserModel} from '../Database/Models/User'
import {Request, Response} from "express"

export default async function createAccount(req: Request, res: Response) {

    const {username, password} = req.body

    if (!username || !password) {
        res.status
    }

    try {
        
        if (await UserModel.exists({username: username})) {
            return res.status(409).json({"message": "Username already exists"})
        }

        let user = await UserModel.create({
            username: username,
            password: password
        })
        return res.status(201).json({"user_id": user._id})
    } catch (err) {
        return res.status(500).json({"Error": "Something went wrong on our end!"})
    }
}