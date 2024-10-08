package com.boot.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.boot.dto.BoardDTO;
//실행시 매퍼파일을 읽어 들이도록 지정 여기서는 mybatis.mapper를 불러들임
@Mapper //spring boot에서는 dao에 mapper붙여야한다.
public interface BoardDAO {
	public ArrayList<BoardDTO> list();
	public void write(HashMap<String, String> param);
	public BoardDTO contentView(HashMap<String, String> param);
//	public void upHit(String boardNo); 생략
	public void modify(HashMap<String, String> param);
	public void delete(HashMap<String, String> param);
}
















