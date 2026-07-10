#!/usr/bin/env python3
"""
批量提取EPUB内容并转换为LaTeX格式
"""

import os
import re
import html
from pathlib import Path
from bs4 import BeautifulSoup

def clean_html_text(text):
    """清理HTML文本"""
    if not text:
        return ""
    # 解码HTML实体
    text = html.unescape(text)
    # 移除多余空白
    text = re.sub(r'\s+', ' ', text)
    return text.strip()

def convert_html_to_latex(soup):
    """将HTML内容转换为LaTeX"""
    latex_content = []
    
    # 处理标题
    for h1 in soup.find_all('h1'):
        title = clean_html_text(h1.get_text())
        # 移除章节编号
        title = re.sub(r'^\d+\.\s*', '', title)
        latex_content.append(f"\\section{{{title}}}")
    
    for h2 in soup.find_all('h2'):
        title = clean_html_text(h2.get_text())
        title = re.sub(r'^\d+\.\d+\.\s*', '', title)
        latex_content.append(f"\\subsection{{{title}}}")
    
    for h3 in soup.find_all('h3'):
        title = clean_html_text(h3.get_text())
        title = re.sub(r'^\d+\.\d+\.\d+\.\s*', '', title)
        latex_content.append(f"\\subsubsection{{{title}}}")
    
    # 处理段落
    for p in soup.find_all('p'):
        text = clean_html_text(p.get_text())
        if text:
            latex_content.append(text)
    
    # 处理列表
    for ul in soup.find_all('ul'):
        latex_content.append("\\begin{itemize}[leftmargin=2cm]")
        for li in ul.find_all('li', recursive=False):
            text = clean_html_text(li.get_text())
            if text:
                latex_content.append(f"\t\\item {text}")
        latex_content.append("\\end{itemize}")
    
    for ol in soup.find_all('ol'):
        latex_content.append("\\begin{enumerate}[leftmargin=2cm]")
        for li in ol.find_all('li', recursive=False):
            text = clean_html_text(li.get_text())
            if text:
                latex_content.append(f"\t\\item {text}")
        latex_content.append("\\end{enumerate}")
    
    # 处理代码块
    for pre in soup.find_all('pre'):
        code_text = pre.get_text()
        latex_content.append("\\begin{lstlisting}")
        latex_content.append(code_text)
        latex_content.append("\\end{lstlisting}")
    
    # 处理表格
    for table in soup.find_all('table'):
        latex_content.append("\\begin{table}[htbp]")
        latex_content.append("\\centering")
        # 简化处理，实际应该更复杂
        latex_content.append("\\begin{tabular}")
        latex_content.append("\\end{tabular}")
        latex_content.append("\\end{table}")
    
    return '\n\n'.join(latex_content)

def process_chapter(chapter_file):
    """处理单个章节文件"""
    with open(chapter_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    soup = BeautifulSoup(content, 'html.parser')
    return convert_html_to_latex(soup)

def main():
    epub_dir = Path("D:/Git/wfbook/虚拟化/Proxmox/epub_content/OEBPS")
    output_file = Path("D:/Git/wfbook/虚拟化/Proxmox/chapters_content.tex")
    
    # 获取所有章节文件
    chapter_files = sorted(epub_dir.glob("ch*.html"))
    
    all_content = []
    
    for ch_file in chapter_files:
        print(f"Processing {ch_file.name}...")
        try:
            content = process_chapter(ch_file)
            all_content.append(f"% {ch_file.name}")
            all_content.append(content)
            all_content.append("\n")
        except Exception as e:
            print(f"Error processing {ch_file.name}: {e}")
    
    # 写入输出文件
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(all_content))
    
    print(f"\nContent extracted to {output_file}")

if __name__ == "__main__":
    main()
