import { z } from "zod";

export const userSessionSchema = z.object({
  id: z.string(),
});
export type UserSession = z.infer<typeof userSessionSchema>;

export const validatedSessionSchema = z.object({
  user: userSessionSchema.optional(),
});

export type ValidatedSession = z.infer<typeof validatedSessionSchema>;
