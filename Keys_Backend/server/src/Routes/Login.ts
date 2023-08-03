import {UserModel} from '../Mongo/Models/User'
import {Request, Response} from "express"
import {argonHash} from "../PasswordManagement/Hash"

export default async function login(req: Request, res: Response) {

    const {username, password} = req.body

    if (!username || !password) {
        res.status(400).json({"message": "Not all fields included in request"})
    }
    
    try {
        let user = await UserModel.findOne({username: username})
        let salt = user?.salt
        if (user) {
            let hashedPassword: String = await argonHash(password, salt!)
            if (user.hash == hashedPassword) {
                req.session.isAuthenticated = true
                return res.status(200).json({"user_id": user._id})
            } else {
                return res.status(400).json({"Error": "Could not find user"})
            }
        } else {
            req.session.isAuthenticated = false
            return res.status(500).json({"Error": "Could not find user"})
        }
    } catch (err) {
        return res.status(500).json({"Error": "Something went wrong on our end!"})
    }
}