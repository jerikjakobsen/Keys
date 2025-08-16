import { UserSession } from "../../Middleware/ValidatedSession";

export const createUserSession = (userId: string): UserSession => {
  return {
    id: userId,
  };
};
