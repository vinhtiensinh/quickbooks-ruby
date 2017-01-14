module Quickbooks
  module Model
    class BillPaymentLineItem < BaseModel

      xml_accessor :id, :from => 'Id'
      xml_accessor :line_num, :from => 'LineNum', :as => Integer
      xml_accessor :description, :from => 'Description'
      xml_accessor :amount, :from => 'Amount', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :detail_type, :from => 'DetailType'

      xml_accessor :linked_transactions, :from => 'LinkedTxn', :as => [LinkedTransaction]

      #== Various detail types
      def initialize(*args)
        self.linked_transactions ||= []
        super
      end

      def bill_id=(id)
        update_linked_transactions([id], 'Bill')
      end

      def vendor_credit_id=(id)
        update_linked_transactions([id], 'VendorCredit')
      end
      alias_method :bill_ids=, :bill_id=
      alias_method :vendor_credit_ids=, :vendor_credit_id=

      private
      def update_linked_transactions(txn_ids, txn_type)
        remove_linked_transactions(txn_type)
        txn_ids.flatten.compact.each do |id|
          add_linked_transaction(id, txn_type)
        end
      end

      def remove_linked_transactions(txn_type)
        self.linked_transactions.delete_if { |lt| lt.txn_type == txn_type }
      end

      def add_linked_transaction(txn_id, txn_type)
        self.linked_transactions << LinkedTransaction.new(txn_id: txn_id,
                                                          txn_type: txn_type)
      end
    end
  end
end
