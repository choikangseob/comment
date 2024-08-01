package com.himedia.mc;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface commentDAO {
	void insert(int id,String content,String writer);
	ArrayList<commentDTO> getView(int id);

}
