package com.coffeeshop.util;

import java.security.MessageDigest;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PasswordUtil {

    /**
     * 将明文密码转换为 SHA-256 哈希值
     * @param password 用户输入的明文密码
     * @return 64位的十六进制字符串
     */
    public static String hashPassword(String password) {
        try {
            // 获取 SHA-256 算法实例
            MessageDigest md = MessageDigest.getInstance("SHA-256");

            // 计算哈希
            byte[] hashedBytes = md.digest(password.getBytes());

            // 将字节数组转换为 16 进制字符串
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                // %02x 表示以 16 进制输出，至少 2 位，不足补 0
                sb.append(String.format("%02x", b));
            }
            return sb.toString();

        } catch (Exception e) {
            Logger.getLogger(PasswordUtil.class.getName()).log(Level.SEVERE, "Password hashing failed", e);
            return null;
        }
    }
}