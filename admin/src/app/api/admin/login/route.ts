import { NextRequest, NextResponse } from 'next/server';
import { BACKEND_URL } from '@/lib/constants';
import { setTokenCookie } from '@/lib/auth';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    const res = await fetch(`${BACKEND_URL}/api/admin/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
    });

    const data = await res.json();

    if (!res.ok || !data.success) {
      return NextResponse.json(
        { success: false, message: data.message || 'Login failed' },
        { status: res.status }
      );
    }

    // Set httpOnly cookie with the JWT token
    const response = NextResponse.json({
      success: true,
      admin: data.admin,
    });
    response.headers.set('Set-Cookie', setTokenCookie(data.token));
    return response;
  } catch {
    return NextResponse.json(
      { success: false, message: 'Failed to connect to server' },
      { status: 500 }
    );
  }
}
