// import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:team_play/config/helpers/failure.dart';
// import 'package:team_play/feature/auth/domain/datasources/auth_datasource.dart';
// import 'package:team_play/feature/auth/domain/entities/user.dart';
// import 'package:team_play/feature/auth/domain/repositories/auth_repository_provisional.dart';

class PersonFirebase {
  Future getPerson() async {
    final Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] =
        'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjhkMDNhZTdmNDczZjJjNmIyNTI3NmMwNjM2MGViOTk4ODdlMjNhYTkiLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoidGVhbSBwbGF5IiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FBY0hUdGR2S1gwU0VLQ21COGhkUldkd1pWa2J2dTNHUWtXa2xkLXo3X29HPXM5Ni1jIiwiaXNzIjoiaHR0cHM6Ly9zZWN1cmV0b2tlbi5nb29nbGUuY29tL3RlYW1wbGF5LTJkYjk0IiwiYXVkIjoidGVhbXBsYXktMmRiOTQiLCJhdXRoX3RpbWUiOjE2ODc2MjMxNzksInVzZXJfaWQiOiJkWmp4NnE1dGtsWlZXdzRnNnh5TVRUakxLUlIyIiwic3ViIjoiZFpqeDZxNXRrbFpWV3c0ZzZ4eU1UVGpMS1JSMiIsImlhdCI6MTY4NzYyMzE3OSwiZXhwIjoxNjg3NjI2Nzc5LCJlbWFpbCI6ImcydGVhbXBsYXlAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZ29vZ2xlLmNvbSI6WyIxMDY0NzcwODQ5OTc5NTY5Mjk1MTMiXSwiZW1haWwiOlsiZzJ0ZWFtcGxheUBnbWFpbC5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJnb29nbGUuY29tIn19.m9qtJ1UWguotoHNE-RJRtPx-RMO6oRAKX2AhHOpuLrWbJrG2_2Q9FmtNj2kiYzzTtnrnUB7OUPmv3Ykw0fdwZq8CYKr3zbBl_JqRA13zZUi1W8zrIyPmCOqtD5viRTrV6Kh6E0pJqHNm0yPNVuI6KvhMSzjLp8FvST1-JYR3xZBQLKBOMjioHlMhgwQNLDdT-AOI3hRTC_79oXDeT1EZ2GXebUJFCm2TkWroWMQ7tJ7fwamd-mrvy_T8yDEAYRnUyeE1NIF9j0da5ANVv2A0Y0B_y7_uI1BusVmXYk6h6nHOTvoAB8iREQyyPpxz0sUfzqjYgoDnwX0zea2iR1Wqbg';
    final response = await dio.get('http://10.0.2.2:3000/api/users/');
    print(response.data);
    return response.data;
  }
}
