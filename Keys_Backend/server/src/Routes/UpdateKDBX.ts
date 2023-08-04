import { S3Client } from "@aws-sdk/client-s3"
import {Upload} from '@aws-sdk/lib-storage'
import Busboy from "busboy"
import { Stream } from "stream"
import {Request, Response} from "express"
require("dotenv").config()

export default async function updateKDBX(req: Request, res: Response) {

    const {isAuthenticated, userID} = req.session

    if (!isAuthenticated || !userID) {
        return res.status(401).json({"message": "User is not authenticated"})
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
        res.status(200).json({"message": "Uploaded Successfully"})
    } catch (err) {
        console.log(err)
        res.status(500).json({"message": "Something went wrong on our end!"})
    }
}