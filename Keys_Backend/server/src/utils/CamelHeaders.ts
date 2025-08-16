import { IncomingHttpHeaders } from "http";

/**
 * Converts dash-separated header names to camelCase.
 * Example: 'x-server-key' -> 'xServerKey'
 */
export function camelCaseHeaders(headers: IncomingHttpHeaders) {
  return Object.fromEntries(
    Object.entries(headers).map(([key, value]) => {
      const camelKey = key.replace(/-([a-z])/g, (_, char) =>
        char.toUpperCase(),
      );
      return [camelKey, Array.isArray(value) ? value[0] : value];
    }),
  );
}
