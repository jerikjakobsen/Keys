import session from 'express-session';

declare module "express-session" {
    interface SessionData {
        isAuthenticated: boolean;
        userID: string
    }
}

export default session