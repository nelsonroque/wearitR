#' Read WearIT Survey data ----
#' @author Nelson Roque, \email{Nelson.Roque@@ucf.edu}
#' @export
#' @param original_data original, pre-processed data
#' @param unnested_data result of `unnest_cogtask_data()`
cogdata_validation <- function(original_data, unnested_data) {
  og_ids = unique(original_data$wearit_uuid)
  un_ids = unique(unnested_data$wearit_uuid)
  overlap_ids = intersect(og_ids, un_ids)
  len_overlap_check = length(overlap_ids) == length(og_ids)
  return(list(ids_overlap = overlap_ids,
              all_records_processed = len_overlap_check))
}
