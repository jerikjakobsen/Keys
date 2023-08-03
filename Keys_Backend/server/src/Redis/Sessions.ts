import session from 'express-session';

declare module "express-session" {
    interface SessionData {
        isAuthenticated: boolean;
    }
}

export default session