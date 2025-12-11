# E_commerce
### dashboard revenue
- US chỉ chiếm 18.4% số đơn nhưng đóng góp 18.17% doanh thu với AOV chỉ 133.88 USD – trong khi FR chỉ 6.8% số đơn nhưng AOV cao nhất 142.42 USD → thị trường Pháp siêu hiệu quả về lợi nhuận.
- Doanh thu tháng 1/2025 đạt 80K USD (cao nhất năm), nhưng tháng 6 giảm mạnh còn 60K → mất 25% doanh thu chỉ trong 5 tháng → cần campaign mùa hè gấp.
![image alt](https://github.com/NTThanh0405/E_commerce/blob/b3342a16fb751eb6a4a01475e659071d6b1a5a24/images/revenue.png) 

### dashboard profit
- Gross Profit Margin toàn năm 2025 đạt 30.33% (200.7K profit từ 662.3K revenue) – thuộc top cao trong ngành đa danh mục, nhưng tháng 5–6 margin rớt mạnh còn 29.4–29.5%.
- Danh mục Sports mang về lợi nhuận cao nhất (36.7K) với Gross Profit Margin khủng 36.72% – vượt xa Electronics (32.06%) dù doanh thu Electronics cao hơn.
![image alt](https://github.com/NTThanh0405/E_commerce/blob/b3342a16fb751eb6a4a01475e659071d6b1a5a24/images/Profit.png)

### dashboard Events
- Add-to-Cart Rate (ATC) đạt 26.38% (92K pageviews → 24K add-to-cart) – cực cao so với benchmark ngành (~10-15%), chứng tỏ product page & pricing rất hấp dẫn.
- Doanh thu từ đơn không giảm giá (0%) gấp gần 4 lần các mức discount khác → discount 5-20% chỉ mang về chưa tới 9M trong khi 0% discount đóng góp 35M → năm 2025 nên giảm mạnh khuyến mãi sâu.
![image alt](https://github.com/NTThanh0405/E_commerce/blob/b3342a16fb751eb6a4a01475e659071d6b1a5a24/images/Events.png)

### dashboard customers
- ARPU toàn khách hàng đạt 153.85 USD – cực cao, nhưng 85.85% khách thuộc nhóm “mass customers” chỉ đóng góp 591K doanh thu, trong khi 14.15% khách “risky” lại mang về đúng 70.45K
- Top 1 khách hàng (ID 17547) chi 2.7K USD trong năm 2025 (gấp 17 lần ARPU trung bình) → chỉ 7 khách top đã chiếm gần 12K revenue
![image alt](https://github.com/NTThanh0405/E_commerce/blob/b3342a16fb751eb6a4a01475e659071d6b1a5a24/images/customers.png)

### dashboard trend_customers
- Nhóm tuổi 29–45 chỉ chiếm 29.91% số khách nhưng đóng góp tới 200K USD (chiếm 30% tổng doanh thu) và có AOV cao nhất → đây chính là “golden segment” cần tập trung marketing & retention mạnh nhất.
![image alt](https://github.com/NTThanh0405/E_commerce/blob/b3342a16fb751eb6a4a01475e659071d6b1a5a24/images/trend_customers.png)

### dashboard corhot
- Khách mới chiếm tỷ lệ thấp nhất vào tháng 10 (chỉ 96 người) nhưng lại là tháng có lượng khách cũ cao nhất (418) → tháng 10 retention cực mạnh, chứng tỏ chương trình giữ chân cuối năm (Black Friday/reminder) đang hoạt động rất tốt
![image alt](https://github.com/NTThanh0405/E_commerce/blob/b3342a16fb751eb6a4a01475e659071d6b1a5a24/images/corhot.png)

# Model predict

### Kết quả mô hình dự đoán Churn (Logistic Regression)

| Chỉ số                  | Giá trị    | Ý nghĩa thực tế cho EchoMart                                      |
|--------------------------|------------|--------------------------------------------------------------------|
| **Accuracy**             | **96.5%**  | Mô hình dự đoán đúng **96.5%** khách hàng sẽ churn hay không – rất cao và đáng tin cậy |
| **Precision (churn)**    | 0.88       | Trong số khách hàng mô hình báo “sẽ churn”, **88% thực sự churn** → giảm lãng phí khi can thiệp |
| **Recall (churn)**       | 0.62       | Phát hiện được **62%** khách hàng thực sự có nguy cơ churn → vẫn còn dư địa cải thiện nhưng đã bắt được phần lớn khách nguy cơ cao |
| **F1-Score (churn)**     | 0.73       | Cân bằng tốt giữa Precision và Recall cho lớp churn                |
| **AUC-ROC**              | **0.97**   | Mô hình có khả năng phân biệt xuất sắc giữa churn và không churn   |

#### Ma trận nhầm lẫn (Confusion Matrix)
|                      | Dự đoán: Không churn | Dự đoán: Churn |
|----------------------|----------------------|----------------|
| **Thực tế: Không churn** | 3676                 | 25             |
| **Thực tế: Churn**       | 114                  | 185            |

→ Chỉ **25** khách hàng trung thành bị nhầm là churn (rất thấp)  
→ Phát hiện được **185/299** khách thực sự churn (khoảng 62%)

#### yếu tố ảnh hưởng (theo hệ số Logistic Regression)
![image alt](https://github.com/NTThanh0405/E_commerce/blob/a636f7e438ae4d573cbf213b07681f5d3555e8ef/images/heatmap.png)
| Biến         | Hệ số          | Ý nghĩa                                                                 |
|--------------|----------------|-------------------------------------------------------------------------|
| **frequency**| **–1.83**      | Mua càng thường xuyên → nguy cơ churn **giảm cực mạnh** (yếu tố quan trọng nhất) |
| **recency**  | **+0.042**     | Càng lâu không mua → nguy cơ churn tăng (dương, nhưng ảnh hưởng nhỏ hơn frequency) |
| **age**      | **–0.0028**    | Tuổi khách hàng **gần như không ảnh hưởng** đến churn                    |
| **monetary** | **–0.0005**    | Giá trị chi tiêu có ảnh hưởng rất nhỏ, gần như không đáng kể            |

**Kết luận chính từ mô hình:**
- **Frequency** là yếu tố **quan trọng nhất** quyết định khách hàng có trung thành hay không → EchoMart nên tập trung mạnh vào việc khuyến khích mua lặp lại.
- Recency vẫn có tác động, nhưng yếu hơn frequency nhiều.
- Monetary và Age hầu như không đóng góp vào việc dự đoán churn trong dữ liệu này.
![image alt](https://github.com/NTThanh0405/E_commerce/blob/a636f7e438ae4d573cbf213b07681f5d3555e8ef/images/predict_model.png)
