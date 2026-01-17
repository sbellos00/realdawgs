package RentIt;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Mock InquiryDAO for deployment without database
 * Stores inquiries in memory (resets on app restart)
 *
 * TO USE THIS: In your JSP files, replace:
 *   InquiryDAO inquiryDAO = new InquiryDAO();
 * WITH:
 *   InquiryDAO inquiryDAO = new MockInquiryDAO();
 *
 * @version 1.0
 */
public class MockInquiryDAO extends InquiryDAO {

    // In-memory storage (will reset when app restarts)
    private static List<Inquiry> mockInquiries = new ArrayList<>();
    private static int nextId = 1;

    @Override
    public int createInquiry(Inquiry inquiry) throws Exception {
        inquiry.setId(nextId++);
        inquiry.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        inquiry.setStatus("new");
        mockInquiries.add(inquiry);
        return inquiry.getId();
    }

    @Override
    public Inquiry getInquiryById(int inquiryId) throws Exception {
        for (Inquiry inquiry : mockInquiries) {
            if (inquiry.getId() == inquiryId) {
                return inquiry;
            }
        }
        return null;
    }

    @Override
    public List<Inquiry> getInquiriesByProperty(int propertyId) throws Exception {
        List<Inquiry> result = new ArrayList<>();
        for (Inquiry inquiry : mockInquiries) {
            if (inquiry.getPropertyId() == propertyId) {
                result.add(inquiry);
            }
        }
        return result;
    }

    @Override
    public List<Inquiry> getInquiriesByUser(int userId) throws Exception {
        List<Inquiry> result = new ArrayList<>();
        for (Inquiry inquiry : mockInquiries) {
            if (inquiry.getUserId() != null && inquiry.getUserId() == userId) {
                result.add(inquiry);
            }
        }
        return result;
    }

    @Override
    public List<Inquiry> getInquiriesByStatus(String status) throws Exception {
        List<Inquiry> result = new ArrayList<>();
        for (Inquiry inquiry : mockInquiries) {
            if (inquiry.getStatus().equalsIgnoreCase(status)) {
                result.add(inquiry);
            }
        }
        return result;
    }

    @Override
    public void updateInquiryStatus(int inquiryId, String newStatus) throws Exception {
        for (Inquiry inquiry : mockInquiries) {
            if (inquiry.getId() == inquiryId) {
                inquiry.setStatus(newStatus);
                return;
            }
        }
        throw new Exception("Inquiry not found");
    }

    @Override
    public int getInquiryCountByProperty(int propertyId) throws Exception {
        int count = 0;
        for (Inquiry inquiry : mockInquiries) {
            if (inquiry.getPropertyId() == propertyId) {
                count++;
            }
        }
        return count;
    }

    @Override
    public void deleteInquiry(int inquiryId) throws Exception {
        mockInquiries.removeIf(inquiry -> inquiry.getId() == inquiryId);
    }
}
