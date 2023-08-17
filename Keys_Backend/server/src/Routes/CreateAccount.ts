import {UserModel} from '../Mongo/Models/User'
import {Request, Response} from "express"
import {argonHash} from "../PasswordManagement/Hash"
import {randomBytes} from 'crypto'

export default async function createAccount(req: Request, res: Response) {

    const {password, email} = req.body

    if (!password || !email) {
        return res.status(400).json({"message": "Not all fields included in request"})
    }

    try {
        
        if (await UserModel.exists({email: email})) {
            return res.status(409).json({"message": "Email already exists"})
        }
        let salt = randomBytes(32).toString('base64')

        let hashedPassword: String = await argonHash(password, salt)

        let user = await UserModel.create({
            email,
            hash: hashedPassword,
            salt
        })
        if (user) {
            req.session.isAuthenticated = true
            req.session.userID = user._id
        }
        return res.status(201).json({"user_id": user._id})
    } catch (err) {
        console.log(err)
        return res.status(500).json({"Error": "Something went wrong on our end!"})
    }
}