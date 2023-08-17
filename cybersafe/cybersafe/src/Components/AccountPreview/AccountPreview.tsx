import React from "react"
import { useState } from "react"
import AccountField from "../../Components/AccountField/AccountField"
import { Typography } from "@mui/material"
import {AccountInterface, Field} from "../../Types/Account"

interface AccountProps {
    account: AccountInterface
}

export const Account = ({account}: AccountProps) => {

    //Get either username or email from account fields
    let target: Field | undefined = undefined;
    target = account.fields.find( field => {
        return field.name == "Username" || field.name == "Email"
    })

    return (
        <div className="container">
            {/*<img src={account.imageURL?.href} style={{width: "20px", height: "20px", display: "inline-block"}}/>*/}
            <div className="fields">
                <Typography style={{textAlign: "left", padding: "5px"}} component="h1">{account.accountName}</Typography>
                {target ? <AccountField field={target} /> : null}
            </div>
        </div>
    )
}