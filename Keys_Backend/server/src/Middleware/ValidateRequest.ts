import { z, ZodError } from "zod";
import { NextFunction, Request, RequestHandler, Response } from "express";
import {
  UserSession,
  ValidatedSession,
  validatedSessionSchema,
} from "./ValidatedSession";
import { Session } from "express-session";
import { camelCaseHeaders } from "../utils/CamelHeaders";

type SessionForAuth<TAuth extends boolean> = TAuth extends true
  ? Omit<ValidatedSession, "user"> & { user: UserSession } // user required
  : ValidatedSession; // user optional

export interface ValidatedRequest<
  TBody = unknown,
  THeaders = unknown,
  TQuery = unknown,
  TAuth extends boolean = false,
> extends Request {
  validatedBody: TBody;
  validatedHeaders: THeaders;
  validatedQuery: TQuery;
  session: Session & {
    validatedSession: SessionForAuth<TAuth>;
  };
}

export type ValidatedRequestHandler<
  TBody extends z.ZodType<any, any> | undefined = undefined,
  THeaders extends z.ZodType<any, any> | undefined = undefined,
  TQuery extends z.ZodType<any, any> | undefined = undefined,
  TAuth extends boolean = false,
> = (
  req: ValidatedRequest<
    TBody extends z.ZodType ? z.infer<TBody> : unknown,
    THeaders extends z.ZodType ? z.infer<THeaders> : unknown,
    TQuery extends z.ZodType ? z.infer<TQuery> : unknown,
    TAuth
  >,
  res: Response,
  next: NextFunction,
) => void | Promise<void> | Response | Promise<Response>;

// Overload when userAuthenticated is true (UserSession should be there)
// Authenticated route overload
export function validateRequest<
  TBody extends z.ZodType<any, any> | undefined = undefined,
  THeaders extends z.ZodType<any, any> | undefined = undefined,
  TQuery extends z.ZodType<any, any> | undefined = undefined,
>(
  schemas: {
    bodySchema?: TBody;
    headerSchema?: THeaders;
    querySchema?: TQuery;
  },
  originalRequestHandler: ValidatedRequestHandler<
    TBody,
    THeaders,
    TQuery,
    true // user required
  >,
  userAuthenticated: true,
): RequestHandler;

// Non-authenticated route overload
export function validateRequest<
  TBody extends z.ZodType<any, any> | undefined = undefined,
  THeaders extends z.ZodType<any, any> | undefined = undefined,
  TQuery extends z.ZodType<any, any> | undefined = undefined,
>(
  schemas: {
    bodySchema?: TBody;
    headerSchema?: THeaders;
    querySchema?: TQuery;
  },
  originalRequestHandler: ValidatedRequestHandler<
    TBody,
    THeaders,
    TQuery,
    false // user optional
  >,
  userAuthenticated?: false,
): RequestHandler;

export function validateRequest<
  TBody extends z.ZodType<any, any> | undefined = undefined,
  THeaders extends z.ZodType<any, any> | undefined = undefined,
  TQuery extends z.ZodType<any, any> | undefined = undefined,
  TAuth extends boolean = false,
>(
  {
    bodySchema,
    headerSchema,
    querySchema,
  }: {
    bodySchema?: TBody;
    headerSchema?: THeaders;
    querySchema?: TQuery;
  },
  originalRequestHandler: ValidatedRequestHandler<
    TBody,
    THeaders,
    TQuery,
    TAuth
  >,
  userAuthenticated = false,
): RequestHandler {
  return (req, res, next) => {
    try {
      const validatedRequest = req as ValidatedRequest<
        TBody extends z.ZodType ? z.infer<TBody> : unknown,
        THeaders extends z.ZodType ? z.infer<THeaders> : unknown,
        TQuery extends z.ZodType ? z.infer<TQuery> : unknown,
        typeof userAuthenticated
      >;
      if (!req.session)
        return res.status(500).json({ error: "Session not found" });
      const rawValidatedSession =
        (req.session as Session & { validatedSession?: any })
          ?.validatedSession || {};
      validatedRequest.session.validatedSession =
        validatedSessionSchema.parse(rawValidatedSession);
      if (userAuthenticated && !validatedRequest.session.validatedSession.user)
        return res.status(401).json({ error: "Unauthorized" });

      if (bodySchema) {
        validatedRequest.validatedBody = bodySchema.parse(req.body) as any;
      }

      if (headerSchema) {
        validatedRequest.validatedHeaders = headerSchema.parse(
          camelCaseHeaders(req.headers),
        ) as any;
      }

      if (querySchema) {
        validatedRequest.validatedQuery = querySchema.parse(req.headers) as any;
      }

      return originalRequestHandler(validatedRequest, res, next);
    } catch (err) {
      if (err instanceof ZodError) {
        return res.status(400).json({
          error: "Validation failed",
          details: err.issues.map((e) => ({
            path: e.path.join("."),
            message: e.message,
          })),
        });
      }
      return next(err);
    }
  };
}
