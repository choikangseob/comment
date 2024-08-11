package com.himedia.mc;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface commentDAO {
	void insert(int id,String content,String writer);
	ArrayList<commentDTO> getView(int id);
	void update(int id, String content);
	void delete(int id);
	ArrayList<commentDTO> readreply();
	void insert1(int par_id,String content,String userid);
	ArrayList<commentDTO> getView1(int id);
	
}
