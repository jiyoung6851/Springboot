package com.boot.controller;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.dto.CommentDTO;
import com.boot.service.CommentService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/comment")
public class CommentController {
	//서비스단
	@Autowired
	private CommentService service;
	
	@PostMapping("/save")
	public @ResponseBody ArrayList<CommentDTO> save(@RequestParam HashMap<String, String> param) {
		log.info("@# save");
		log.info("@# param => "+param);
		
		service.save(param);
		
		//해당 게시글에 작성된 댓글 리스트를 가져옴
		ArrayList<CommentDTO> commentList = service.findAll(param);
		return commentList;
	}
}
