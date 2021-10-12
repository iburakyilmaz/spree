module Spree
  module Api
    module V2
      module Platform
        class OrdersController < ResourceController
          WRITE_ACTIONS.push(:ready, :ship, :cancel, :resume, :pend)

          def create
            order = Spree::Order.find_by!(number: params.fetch(:shipment).fetch(:order_id))
            quantity = params[:quantity].to_i
            resource = order.shipments.create(stock_location_id: params.fetch(:stock_location_id))

            # line_item = Spree::Dependencies.cart_add_item_service.constantize.call(order: order,
            #                                                                        variant: variant,
            #                                                                        quantity: quantity,
            #                                                                       options: { shipment: resource }).value

            respond_with(resource.reload, default_template: :show)
          end

          def update
            resource.update_attributes_and_order(shipment_params)

            respond_with(resource.reload, default_template: :show)
          end

          def ready
            unless resource.ready?
              if resource.can_ready?
                resource.ready!
              else
                render 'spree/api/v1/shipments/cannot_ready_shipment', status: 422 and return
              end
            end
            respond_with(resource, default_template: :show)
          end

          def ship
            resource.ship! unless resource.shipped?
            respond_with(resource, default_template: :show)
          end

          private

          def model_class
            Spree::Shipment
          end

          def resource
            @resource ||= scope.find_by(number: params[:id]) || scope.find(params[:id])
          end

          def authorize_spree_user
            return if spree_current_user.nil?

            if action_name == 'create'
              spree_authorize! :create, model_class
            elsif %w[ready ship cancel resume pend].include?(action_name)
              spree_authorize! :update, resource
            else
              spree_authorize! action_name, resource
            end
          end

          def spree_permitted_attributes
            Spree::Order.json_api_permitted_attributes + [
              bill_address_attributes: Spree::Address.json_api_permitted_attributes,
              ship_address_attributes: Spree::Address.json_api_permitted_attributes,
              line_items_attributes: Spree::LineItem.json_api_permitted_attributes,
              payments_attributes: Spree::Payment.json_api_permitted_attributes + [
                source_attributes: Spree::CreditCard.json_api_permitted_attributes
              ],
              shipments_attributes: Spree::Shipment.json_api_permitted_attributes
            ]
          end
        end
      end
    end
  end
end
