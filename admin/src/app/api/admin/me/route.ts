import { NextResponse } from 'next/server';
import { getToken } from '@/lib/auth';

export async function GET() {
  const token = await getToken();

  if (!token) {
    return NextResponse.json(
      { success: false, message: 'Not authenticated' },
      { status: 401 }
    );
  }

  try {
    // Decode JWT payload (base64) without verification - verification happens on backend
    const payload = JSON.parse(
      Buffer.from(token.split('.')[1], 'base64').toString()
    );

    return NextResponse.json({
      success: true,
      admin: {
        id: payload.id,
        name: payload.name,
        email: payload.email,
        role: payload.role,
      },
    });
  } catch {
    return NextResponse.json(
      { success: false, message: 'Invalid token' },
      { status: 401 }
    );
  }
}
