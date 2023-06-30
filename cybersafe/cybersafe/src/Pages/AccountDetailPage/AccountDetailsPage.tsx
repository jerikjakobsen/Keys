import React, { useState } from 'react';
import "./PasswordsPage.css"
import {motion} from 'framer-motion'
import {Account} from '../../Components/Account/Account';
import { AccountInterface } from '../../Types/Account';

export const AccountDetailPage = () => {

    const acc: AccountInterface = {
        accountName: "Gmail",
        imageURL: new URL("https://cdn2.downdetector.com/static/uploads/c/300/0b9c5/image21.png"),
        fields: [{
            name: "email",
            value: "go4johne@gmail.com",
            type: "email"
        },
        {
            name: "username",
            value: "go4johne",
            type: "username" 
        },
    ],
        id: "123"
    }

    return (
        <motion.div className="scroller"
        initial={{opacity: 0}}
        animate={{opacity: 1}}
        exit={{opacity: 1}}>
            <Account account={acc} />
        </motion.div>
    )
}

export default AccountDetailPage;