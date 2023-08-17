import {Request, Response, NextFunction} from 'express'
import dotenv from 'dotenv'
dotenv.config()

export default function AuthenticateRequest(req: Request, res: Response, next: NextFunction) {
    const server_key = process.env.SERVER_KEY
    
    if (!req.cookies.server_key || server_key !== req.cookies.server_key) {
        return res.status(400).json({"message": "Request not authenticated"})
    }

    return next()
}