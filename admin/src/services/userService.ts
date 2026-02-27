import api from './api';

export const userService = {
  async getUsers(params: { page?: number; search?: string; classLevel?: string }) {
    const response = await api.get('/admin/users', { params });
    return response.data;
  },

  async getUserDetail(id: string) {
    const response = await api.get(`/admin/users/${id}`);
    return response.data;
  },

  async deleteUser(id: string) {
    const response = await api.delete(`/admin/users/${id}`);
    return response.data;
  },
};
