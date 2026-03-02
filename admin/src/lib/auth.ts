import { cookies } from 'next/headers';

const COOKIE_NAME = 'admin_token';

export async function getToken(): Promise<string | null> {
  const cookieStore = await cookies();
  return cookieStore.get(COOKIE_NAME)?.value || null;
}

export function setTokenCookie(token: string): string {
  // Returns Set-Cookie header value
  const maxAge = 24 * 60 * 60; // 24 hours
  return `${COOKIE_NAME}=${token}; Path=/; HttpOnly; SameSite=Lax; Max-Age=${maxAge}`;
}

export function clearTokenCookie(): string {
  return `${COOKIE_NAME}=; Path=/; HttpOnly; SameSite=Lax; Max-Age=0`;
}
