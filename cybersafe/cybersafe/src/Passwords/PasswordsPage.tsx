import React, { useState } from 'react';
import AccountField from './Components/AccountField';
import "./PasswordsPage.css"
import {motion} from 'framer-motion'
import {Account, AccountInterface, Field} from './Components/Account';

const PasswordsPage: React.FC = () => {

    const [accounts, setAccounts] = useState<AccountInterface[]>([{
        accountName: "Gmail",
        imageURL: new URL("https://cdn2.downdetector.com/static/uploads/c/300/0b9c5/image21.png"),
        fields: [{
            name: "email",
            value: "go4johne@gmail.com",
            type: "email"
        }]
    }]);

    return (
        <motion.div className="scroller"
        initial={{opacity: 0}}
        animate={{opacity: 1}}
        exit={{opacity: 1}}>
            {
                accounts.map((acc) => (
                    <Account account={acc} />
                ))
            }
        </motion.div>
    )
}

export default PasswordsPage;