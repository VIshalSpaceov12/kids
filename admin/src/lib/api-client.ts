import { getToken } from './auth';
import { BACKEND_URL } from './constants';

export async function backendFetch(
  path: string,
  options: RequestInit = {}
): Promise<Response> {
  const token = await getToken();
  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
    ...(options.headers as Record<string, string>),
  };

  if (token) {
    headers['Authorization'] = `Bearer ${token}`;
  }

  const url = `${BACKEND_URL}${path}`;
  return fetch(url, {
    ...options,
    headers,
    cache: 'no-store',
  });
}
