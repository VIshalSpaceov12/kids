import { createContext, useState, useEffect, useCallback, type ReactNode } from 'react';
import type { AdminUser, AuthState } from '../types';

const MOCK_ADMIN: AdminUser = {
  id: 'admin-001',
  name: 'Admin',
  email: 'admin@chhotu.com',
  role: 'superadmin',
};

const MOCK_PASSWORD = 'admin123';

export const AuthContext = createContext<AuthState | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<AdminUser | null>(null);
  const [token, setToken] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const storedToken = localStorage.getItem('admin_token');
    const storedUser = localStorage.getItem('admin_user');
    if (storedToken && storedUser) {
      try {
        setToken(storedToken);
        setUser(JSON.parse(storedUser));
      } catch {
        localStorage.removeItem('admin_token');
        localStorage.removeItem('admin_user');
      }
    }
    setLoading(false);
  }, []);

  const login = useCallback(async (email: string, password: string) => {
    // Simulate network delay
    await new Promise((resolve) => setTimeout(resolve, 600));

    if (email === MOCK_ADMIN.email && password === MOCK_PASSWORD) {
      const mockToken = 'mock-jwt-token-chhotu-genius-admin-2024';
      localStorage.setItem('admin_token', mockToken);
      localStorage.setItem('admin_user', JSON.stringify(MOCK_ADMIN));
      setToken(mockToken);
      setUser(MOCK_ADMIN);
      return;
    }
    throw new Error('Invalid email or password');
  }, []);

  const logout = useCallback(() => {
    localStorage.removeItem('admin_token');
    localStorage.removeItem('admin_user');
    setToken(null);
    setUser(null);
  }, []);

  if (loading) {
    return (
      <div className="flex h-screen items-center justify-center bg-gray-50">
        <div className="text-lg text-gray-500">Loading...</div>
      </div>
    );
  }

  return (
    <AuthContext.Provider
      value={{
        user,
        token,
        isAuthenticated: !!token && !!user,
        login,
        logout,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}
