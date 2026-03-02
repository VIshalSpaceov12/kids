import { NextRequest, NextResponse } from 'next/server';
import { backendFetch } from '@/lib/api-client';

export async function GET(request: NextRequest) {
  const lessonId = request.nextUrl.searchParams.get('lessonId');
  if (!lessonId) {
    return NextResponse.json(
      { success: false, message: 'lessonId is required' },
      { status: 400 }
    );
  }
  // Uses public content endpoint
  const res = await backendFetch(`/api/content/lessons/${lessonId}/questions`);
  const data = await res.json();
  return NextResponse.json(data, { status: res.status });
}

export async function POST(request: NextRequest) {
  const body = await request.json();
  const res = await backendFetch('/api/admin/content/questions', {
    method: 'POST',
    body: JSON.stringify(body),
  });
  const data = await res.json();
  return NextResponse.json(data, { status: res.status });
}
