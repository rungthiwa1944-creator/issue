<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Workflow Error Lookup</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            min-height: 100vh;
            color: #e0e0e0;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        header {
            text-align: center;
            padding: 40px 0;
        }

        header h1 {
            font-size: 2.5rem;
            color: #00d4ff;
            margin-bottom: 10px;
            text-shadow: 0 0 20px rgba(0, 212, 255, 0.3);
        }

        header p {
            color: #888;
            font-size: 1.1rem;
        }

        .search-section {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .search-box {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }

        .search-input {
            flex: 1;
            padding: 15px 25px;
            font-size: 1rem;
            border: 2px solid rgba(0, 212, 255, 0.3);
            border-radius: 50px;
            background: rgba(0, 0, 0, 0.3);
            color: #fff;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: #00d4ff;
            box-shadow: 0 0 20px rgba(0, 212, 255, 0.2);
        }

        .search-input::placeholder {
            color: #666;
        }

        .search-btn {
            padding: 15px 40px;
            font-size: 1rem;
            font-weight: 600;
            background: linear-gradient(135deg, #00d4ff 0%, #0099cc 100%);
            color: #000;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(0, 212, 255, 0.3);
        }

        .filter-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .filter-tag {
            padding: 8px 16px;
            font-size: 0.85rem;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .filter-tag:hover, .filter-tag.active {
            background: rgba(0, 212, 255, 0.2);
            border-color: #00d4ff;
            color: #00d4ff;
        }

        .stats-bar {
            display: flex;
            justify-content: center;
            gap: 40px;
            margin-bottom: 30px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 15px;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: #00d4ff;
        }

        .stat-label {
            font-size: 0.9rem;
            color: #888;
        }

        .results-section {
            display: grid;
            gap: 20px;
        }

        .error-card {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 16px;
            padding: 25px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .error-card:hover {
            transform: translateY(-5px);
            border-color: rgba(0, 212, 255, 0.5);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
        }

        .error-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }

        .error-number {
            background: linear-gradient(135deg, #ff6b6b 0%, #ff8e53 100%);
            color: #fff;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .reference-tag {
            background: rgba(0, 212, 255, 0.2);
            color: #00d4ff;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
        }

        .error-message {
            font-family: 'Consolas', 'Monaco', monospace;
            background: rgba(0, 0, 0, 0.4);
            padding: 15px;
            border-radius: 10px;
            font-size: 0.9rem;
            color: #ff6b6b;
            margin-bottom: 20px;
            word-break: break-word;
            border-left: 3px solid #ff6b6b;
        }

        .error-details {
            display: none;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .error-card.expanded .error-details {
            display: block;
        }

        .detail-section {
            margin-bottom: 20px;
        }

        .detail-label {
            font-size: 0.85rem;
            color: #00d4ff;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .detail-label::before {
            content: '';
            width: 8px;
            height: 8px;
            background: currentColor;
            border-radius: 50%;
        }

        .detail-content {
            color: #ccc;
            line-height: 1.6;
            padding-left: 16px;
        }

        .solution-box {
            background: rgba(46, 204, 113, 0.1);
            border: 1px solid rgba(46, 204, 113, 0.3);
            border-radius: 10px;
            padding: 15px;
        }

        .solution-box .detail-content {
            color: #2ecc71;
        }

        .expand-hint {
            text-align: center;
            color: #666;
            font-size: 0.85rem;
            margin-top: 10px;
        }

        .no-results {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .no-results-icon {
            font-size: 4rem;
            margin-bottom: 20px;
        }

        .highlight {
            background: rgba(255, 235, 59, 0.3);
            padding: 2px 4px;
            border-radius: 3px;
        }

        @media (max-width: 768px) {
            header h1 {
                font-size: 1.8rem;
            }

            .search-box {
                flex-direction: column;
            }

            .search-btn {
                width: 100%;
            }

            .stats-bar {
                flex-direction: column;
                gap: 20px;
            }
        }

        .fade-in {
            animation: fadeIn 0.5s ease forwards;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>🔍 Workflow Error Lookup</h1>
            <p>ค้นหาและแก้ไขปัญหา Workflow Error ใน D365 F&O</p>
        </header>

        <div class="search-section">
            <div class="search-box">
                <input type="text" class="search-input" id="searchInput" 
                       placeholder="พิมพ์ข้อความ error หรือ reference number...">
                <button class="search-btn" onclick="searchErrors()">ค้นหา</button>
            </div>
            <div class="filter-tags">
                <span class="filter-tag" onclick="filterByCategory('all')">ทั้งหมด</span>
                <span class="filter-tag" onclick="filterByCategory('permission')">Permission</span>
                <span class="filter-tag" onclick="filterByCategory('dimension')">Financial Dimension</span>
                <span class="filter-tag" onclick="filterByCategory('workflow')">Workflow Config</span>
                <span class="filter-tag" onclick="filterByCategory('data')">Data Issue</span>
                <span class="filter-tag" onclick="filterByCategory('budget')">Budget</span>
            </div>
        </div>

        <div class="stats-bar">
            <div class="stat-item">
                <div class="stat-number" id="totalErrors">20</div>
                <div class="stat-label">Total Errors</div>
            </div>
            <div class="stat-item">
                <div class="stat-number" id="displayedCount">20</div>
                <div class="stat-label">แสดงผล</div>
            </div>
        </div>

        <div class="results-section" id="resultsContainer">
            <!-- Results will be rendered here -->
        </div>
    </div>

    <script>
        const errorData = [
            {
                no: 1,
                message: "Stopped(error):X++ Exception: Work item could not be created. Insuffcient security permissions for user",
                cause: "สิทธิ์ของ User ท่านนั้นใน workflow ไม่ถึง",
                solution: "เพิ่ม Roles ใหม่ และกด Resume ให้ workflow อีกครั้งนึง",
                reference: "73990",
                category: "permission"
            },
            {
                no: 2,
                message: "Stopped(error):Journal",
                cause: "Workflow เข้าสู่สถานะ Fault เนื่องจาก Journal อยู่ระหว่างการ Post หรือถูกใช้งานโดย Process อื่น ทำให้ไม่สามารถเปลี่ยนสถานะเอกสารได้",
                solution: "Resume Workflow",
                reference: "74270",
                category: "workflow"
            },
            {
                no: 3,
                message: "Stopped (error): X++ Exception: The text associated with this work item cannot be found in the assignee's language, or in the default language for the system or legal entity. The workflow has stopped processing because of this error. Contact your system administrator for assistance.",
                cause: "language setting ของ User ไม่เหมือนกัน",
                solution: "ปัญหาได้รับการแก้ไขหลังจากปรับการตั้งค่าภาษา Legal Entity, User Options และ Worker ให้สอดคล้องกัน และหากใช้งานหลายภาษา ควรกำหนด Workflow Translation ให้เหมาะสม",
                reference: "72494",
                category: "workflow"
            },
            {
                no: 4,
                message: "Stopped (error): Ledger account validated using 12073003-2010000-BAU_2026-Z000001-900001----2026-00000----, Record Id: 5638875654 Dimension values were validated with this account structure: SHARE The combination was not validated beyond the FD05_SystemIT financial dimens",
                cause: "ใน structure บัญชี มีบังคับให้ระบุ Financial dimension ให้ครบ",
                solution: "Recall PR แก้ไข Financial dimension และ submit ใหม่",
                reference: "73838",
                category: "dimension"
            },
            {
                no: 5,
                message: "Stopped(error):X++ Exception: A User is not",
                cause: "มี worker แต่ไม่มี User ในระบบเพื่อใช้อนุมัติ",
                solution: "เพิ่ม User และ ผูก worker",
                reference: "73354",
                category: "permission"
            },
            {
                no: 6,
                message: "User มองไม่เห็นปุ่ม Resume ใน Workflow history",
                cause: "User มองไม่เห็นปุ่ม Resume ใน Workflow history",
                solution: "เพิ่ม roles: Information technology manager",
                reference: "73541",
                category: "permission"
            },
            {
                no: 7,
                message: "Stopped (error): Ledger account validated using 551610-41101-BG2025-C2103-BOI_NO------00000, Record Id: 5637165580 The combination was not validated beyond the D02_BudgetCode financial dimension. D01_Departments 41101 is valid. MainAccount 551610 is valid. D02_BudgetCode",
                cause: "Financial dimension: D02_BudgetCode not Active",
                solution: "แก้ไข Financial dimension และ resume workflow",
                reference: "73499",
                category: "dimension"
            },
            {
                no: 8,
                message: "Stopped (error): Accounting distribution validation failed. Please recall purchase order workflow and rectify accounting distributions. This action can only be completed after the line number 70 is fully distributed.",
                cause: "ข้อมูลของ distribute amount ไม่สมบูรณ์",
                solution: "recall รายการกลับมาและไปที่ line นั้นและกด financial > distribute amount และทำการกด reset",
                reference: "73629",
                category: "data"
            },
            {
                no: 9,
                message: "Stopped (unrecoverable): Cannot edit a record in Purchase orders (PurchTable). An update conflict occurred due to another user process deleting the record or changing one or more fields in the record.",
                cause: "เกิดจากข้อมูลถูกแก้ไขหรือลบระหว่างการประมวลผล ส่งผลให้ระบบไม่สามารถอัปเดตข้อมูลได้",
                solution: "Recall และ submit ใหม่",
                reference: "73522",
                category: "data"
            },
            {
                no: 10,
                message: "Stopped (error): X++ Exception: A job was not defined for position '50-1-223' that is associated with worker '50-1-223'. Go to 'Positions' and verify position '50-1-223' has a job defined. at SysWorkflowHierarchyProvider-resolve SysWorkflowHierarchyProvider-resolveHierarc",
                cause: "ไม่ได้ระบุ Job สำหรับ User นี้",
                solution: "ระบุ job title ใน position ที่ error",
                reference: "73471",
                category: "workflow"
            },
            {
                no: 11,
                message: "Stopped (error): Update has been canceled. Inventory dimension Warehouse must be: WH-02",
                cause: "PO มาจาก master plan ซึ่งรายการยังมีการค้าง Master plan ที่ line ที่ 3 ของ production order อยู่ซึ่งเป็น WH02 ทำให้เกิด error",
                solution: "แนะนำให้ตั้งค่าในขั้นตอน Plan to PO โดยเลือก 'No' ในระหว่างการ Firm เพื่อไม่ให้มีการอ้างอิง PO ไปยัง PD ซึ่งอาจช่วยป้องกันการเกิด Error ในอนาคต",
                reference: "72983",
                category: "data"
            },
            {
                no: 12,
                message: "Stopped (error): Workflow message '{62F73FE0-C22A-4655-8EE6-B6879C312257}' has exceeded the maximum retry attempts of 5.",
                cause: "workflow ทำงานซ้ำเกินกำหนด",
                solution: "ปรับ Parameter ที่ชื่อ Maximum number of attempts จาก Default เป็น 0 ให้ปรับเป็น 10\n*Maximum number of attempts = จำนวนครั้งที่ระบบจะ retry Workflow อัตโนมัติเมื่อเกิด error",
                reference: "72600",
                category: "workflow"
            },
            {
                no: 13,
                message: "The system cannot determine which workflow to run. Review the conditions in the 'Set condition for use' area for each workflow that is based on the Purchase requisition review type.",
                cause: "ส่วนมากจะเกิดขึ้นเมื่อ PR ไม่สามารถหา condition ในการวิ่งได้ หรือมีการ Set condition ซ้อนกัน",
                solution: "เพิ่มเงื่อนไข หรือแก้ไข workflow",
                reference: "72289",
                category: "workflow"
            },
            {
                no: 14,
                message: "Stopped (error): Update has been canceled. Ordered quantity may not be reduced by 3,000.00 because the available quantity then will be negative.",
                cause: "ปริมาณสั่งซื้อไม่สามารถลดได้เนื่องจากจะทำให้ปริมาณคงเหลือติดลบ",
                solution: "run script > recall workflow และ submit PO",
                reference: "71222",
                category: "data"
            },
            {
                no: 15,
                message: "Stopped (error): This transaction has been marked for settlement by สมุดเงินยืมทดรอง-สาขาสำนักงาน คปภ. ภาค 9 BN000455798 in company oic.",
                cause: "Error เกิดจากรายการถูก mark for settlement ไว้กับ BN000455798 จึงไม่สามารถทำรายการใหม่ได้ เนื่องจากเป็นรายการเดิมที่ต้องการแก้ไข",
                solution: "แนะนำให้ลบรายการเดิมและ resume workflow ใหม่",
                reference: "71420",
                category: "data"
            },
            {
                no: 16,
                message: "กด Submit PR Error : One or more accounting distribution is missing a ledger account or contains a ledger account that is not valid. Use the Accounting distribution form or the Posting profile to update the ledger account.",
                cause: "Category ไม่ได้ผูก Posting",
                solution: "ผูก Posting",
                reference: "71149/0064897",
                category: "dimension"
            },
            {
                no: 17,
                message: "Stopped (error): ClrInterop Exception: Exception has been thrown by the target of an invocation. Function 'ConvertAmountValue()' has failed. X++ Exception: A currency to convert from is required to retrieve exchange rate information. at SysWorkflowEvaluationProvider-evalu",
                cause: "ไม่ได้ระบุ currency ในรายการ",
                solution: "ระบุ currency ในรายการ",
                reference: "70478",
                category: "data"
            },
            {
                no: 18,
                message: "An exchange rate cannot be found for exchange rate type Default between currencies CAS and THB on exchange date 17/03/2025. Stopped (unrecoverable): An exchange rate cannot be found for exchange rate type Default between currencies CAS and THB on exchange date 17/3/2025.",
                cause: "ไม่ได้ setup Exchange rate",
                solution: "PR Submit ไปแล้ว recall กลับมาแก้ไขไม่ได้ ต้อง Run script ให้ PR Cancelled และเปิด PR ใหม่",
                reference: "64120",
                category: "data"
            },
            {
                no: 19,
                message: "Stopped (error): Update has been canceled. Quantity should have the same sign in both the posting unit and the inventory unit.",
                cause: "Inventory unit และ Quantity ไม่ตรงกัน",
                solution: "Recall workflow > แก้ไข Inventory unit ให้ติดลบเหมือน Quantity > Submit ใหม่",
                reference: "61184",
                category: "data"
            },
            {
                no: 20,
                message: "No workflow id defined",
                cause: "workflow Version ไม่ได้ Active และ flow ดังกล่าวไม่มี Owner ของ Workflow / หรือ Period ไม่เปิด / หรือ Budget ไม่พอ",
                solution: "1) ระบุ Owner ของ Workflow และกด Active (Ref: 61039)\n2) เปิด Period และ perform budget checking อีกครั้ง (Ref: 56819)\n3) เพิ่ม budget และ submit ใหม่ (Ref: 54121)",
                reference: "61039, 56819, 54121",
                category: "workflow"
            }
        ];

        let currentFilter = 'all';

        function renderResults(data, searchTerm = '') {
            const container = document.getElementById('resultsContainer');
            document.getElementById('displayedCount').textContent = data.length;

            if (data.length === 0) {
                container.innerHTML = `
                    <div class="no-results">
                        <div class="no-results-icon">🔎</div>
                        <h3>ไม่พบผลลัพธ์</h3>
                        <p>ลองค้นหาด้วยคำอื่น หรือเลือกหมวดหมู่อื่น</p>
                    </div>
                `;
                return;
            }

            container.innerHTML = data.map((error, index) => {
                let displayMessage = error.message;
                if (searchTerm) {
                    const regex = new RegExp(`(${escapeRegex(searchTerm)})`, 'gi');
                    displayMessage = displayMessage.replace(regex, '<span class="highlight">$1</span>');
                }

                return `
                    <div class="error-card fade-in" style="animation-delay: ${index * 0.05}s" onclick="toggleCard(this)">
                        <div class="error-header">
                            <span class="error-number">Error #${error.no}</span>
                            <span class="reference-tag">Ref: ${error.reference}</span>
                        </div>
                        <div class="error-message">${displayMessage}</div>
                        <div class="expand-hint">👆 คลิกเพื่อดูสาเหตุและวิธีแก้ไข</div>
                        <div class="error-details">
                            <div class="detail-section">
                                <div class="detail-label">สาเหตุ</div>
                                <div class="detail-content">${error.cause}</div>
                            </div>
                            <div class="detail-section solution-box">
                                <div class="detail-label">วิธีแก้ไข</div>
                                <div class="detail-content">${error.solution.replace(/\n/g, '<br>')}</div>
                            </div>
                        </div>
                    </div>
                `;
            }).join('');
        }

        function escapeRegex(string) {
            return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
        }

        function toggleCard(card) {
            card.classList.toggle('expanded');
            const hint = card.querySelector('.expand-hint');
            if (card.classList.contains('expanded')) {
                hint.textContent = '👆 คลิกเพื่อย่อ';
            } else {
                hint.textContent = '👆 คลิกเพื่อดูสาเหตุและวิธีแก้ไข';
            }
        }

        function searchErrors() {
            const searchTerm = document.getElementById('searchInput').value.trim().toLowerCase();
            let filtered = errorData;

            if (currentFilter !== 'all') {
                filtered = filtered.filter(e => e.category === currentFilter);
            }

            if (searchTerm) {
                filtered = filtered.filter(e => 
                    e.message.toLowerCase().includes(searchTerm) ||
                    e.cause.toLowerCase().includes(searchTerm) ||
                    e.solution.toLowerCase().includes(searchTerm) ||
                    e.reference.toLowerCase().includes(searchTerm)
                );
            }

            renderResults(filtered, searchTerm);
        }

        function filterByCategory(category) {
            currentFilter = category;
            
            document.querySelectorAll('.filter-tag').forEach(tag => {
                tag.classList.remove('active');
            });
            event.target.classList.add('active');

            searchErrors();
        }

        // Initialize
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchErrors();
            }
        });

        document.getElementById('searchInput').addEventListener('input', function() {
            if (this.value === '') {
                searchErrors();
            }
        });

        renderResults(errorData);
    </script>
</body>
</html>
