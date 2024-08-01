package com.himedia.mc;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;
@Mapper
public interface signupDAO {
void getMember(String userid,String password,String name,String birthday,String gender,String mobile,String favorite);
int logMember(String userid,String passwd);
}
