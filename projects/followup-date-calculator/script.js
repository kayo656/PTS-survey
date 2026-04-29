document.addEventListener('DOMContentLoaded', () => {
    const startDateInput = document.getElementById('startDate');
    
    // Set default date to today
    const today = new Date();
    const yyyy = today.getFullYear();
    const mm = String(today.getMonth() + 1).padStart(2, '0');
    const dd = String(today.getDate()).padStart(2, '0');
    startDateInput.value = `${yyyy}-${mm}-${dd}`;

    // Initial calculation
    calculateDates();

    // Event listener for date change
    startDateInput.addEventListener('change', calculateDates);
});

function calculateDates() {
    const startDateValue = document.getElementById('startDate').value;
    if (!startDateValue) return;

    const baseDate = new Date(startDateValue);
    const dayOfWeekStr = ['日', '月', '火', '水', '木', '金', '土'];

    document.querySelectorAll('.card').forEach(card => {
        const days = parseInt(card.dataset.days);
        const followupDate = new Date(baseDate);
        followupDate.setDate(baseDate.getDate() + days);

        const year = followupDate.getFullYear();
        const month = String(followupDate.getMonth() + 1).padStart(2, '0');
        const day = String(followupDate.getDate()).padStart(2, '0');
        const dow = dayOfWeekStr[followupDate.getDay()];

        card.querySelector('.calc-date').textContent = `${year}/${month}/${day}`;
        card.querySelector('.day-of-week').textContent = `(${dow})`;
    });
}

function downloadICS(days) {
    const startDateValue = document.getElementById('startDate').value;
    if (!startDateValue) {
        alert('基準日を選択してください');
        return;
    }

    const baseDate = new Date(startDateValue);
    const followupDate = new Date(baseDate);
    followupDate.setDate(baseDate.getDate() + days);

    const year = followupDate.getFullYear();
    const month = String(followupDate.getMonth() + 1).padStart(2, '0');
    const day = String(followupDate.getDate()).padStart(2, '0');
    
    // Format for ICS (YYYYMMDD)
    const dateStr = `${year}${month}${day}`;
    // End date for all-day event is the next day in ICS
    const nextDay = new Date(followupDate);
    nextDay.setDate(followupDate.getDate() + 1);
    const endDateStr = `${nextDay.getFullYear()}${String(nextDay.getMonth() + 1).padStart(2, '0')}${String(nextDay.getDate()).padStart(2, '0')}`;

    const title = `フォローアップ（${days}日後）`;
    const description = `臨床研究フォローアップ用\n基準日: ${startDateValue}`;

    const icsContent = [
        "BEGIN:VCALENDAR",
        "VERSION:2.0",
        "PRODID:-//Clinical Research Tool//Follow-up Calc//JP",
        "BEGIN:VEVENT",
        `SUMMARY:${title}`,
        `DTSTART;VALUE=DATE:${dateStr}`,
        `DTEND;VALUE=DATE:${endDateStr}`,
        `DESCRIPTION:${description}`,
        "STATUS:CONFIRMED",
        "SEQUENCE:0",
        "TRANSP:TRANSPARENT",
        "END:VEVENT",
        "END:VCALENDAR"
    ].join("\r\n");

    const blob = new Blob([icsContent], { type: 'text/calendar;charset=utf-8' });
    const link = document.createElement('a');
    link.href = window.URL.createObjectURL(blob);
    link.setAttribute('download', `followup_${days}d.ics`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}
