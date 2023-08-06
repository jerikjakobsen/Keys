import { S3Client } from "@aws-sdk/client-s3"
import {Upload} from '@aws-sdk/lib-storage'
import { Stream } from "stream"
import {Request, Response} from "express"
import { UserModel } from '../Mongo/Models/User';
require("dotenv").config()
import UploadMessages from "./Messages/UploadMessages";

export default async function updateKDBX(req: Request, res: Response) {

    const {isAuthenticated, userID} = req.session
    let {dateUpdated, overwrite} = req.query

    if (!isAuthenticated || !userID) {
        return res.status(401).json({"message": "User is not authenticated"})
    }

    if (!dateUpdated) {
        dateUpdated = Date.now().toString()
    }

    let dateConvertedToNumber = Number(dateUpdated)

    let user = await UserModel.findById(userID)
    if (!user) {
        return res.status(500).json({"message": "User not found"})
    }

    if (user.dbUpdatedAt > new Date(dateConvertedToNumber) && !overwrite) {
        return res.status(400).json({"message": UploadMessages.OverwriteMessage})
    }

    let stream = new Stream.PassThrough()
    req.pipe(stream)
    const uploadParams = {
        Bucket: process.env.AWS_BUCKET,
        Key: `${userID}`,
        Body: stream
        };
        
    try {
        const uploadToS3 = new Upload({
            client: new S3Client({region: process.env.AWS_REGION}),
            params: uploadParams
        })

        await uploadToS3.done()

        user.dbUpdatedAt = new Date(dateConvertedToNumber)
        await user.save()

        return res.status(200).json({"message": "Uploaded Successfully"})
    } catch (err) {
        console.log(err)
        return res.status(500).json({"message": "Something went wrong on our end!"})
    }
}