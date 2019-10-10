
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: G Suite Alert Center
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages alerts on issues affecting your domain.
## 
## https://developers.google.com/admin-sdk/alertcenter/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "alertcenter"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AlertcenterAlertsList_588710 = ref object of OpenApiRestCall_588441
proc url_AlertcenterAlertsList_588712(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AlertcenterAlertsList_588711(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the alerts.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. A token identifying a page of results the server should return.
  ## If empty, a new iteration is started. To continue an iteration, pass in
  ## the value from the previous ListAlertsResponse's
  ## next_page_token field.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alerts are associated with.
  ## Inferred from the caller identity if not provided.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: JString
  ##          : Optional. The sort order of the list results.
  ## If not specified results may be returned in arbitrary order.
  ## You can sort the results in descending order based on the creation
  ## timestamp using `order_by="create_time desc"`.
  ## Currently, supported sorting are `create_time asc`, `create_time desc`,
  ## `update_time desc`
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The requested page size. Server may return fewer items than
  ## requested. If unspecified, server picks an appropriate default.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional. A query string for filtering alert results.
  ## For more details, see [Query
  ## filters](/admin-sdk/alertcenter/guides/query-filters) and [Supported
  ## query filter
  ## fields](/admin-sdk/alertcenter/reference/filter-fields#alerts.list).
  section = newJObject()
  var valid_588824 = query.getOrDefault("upload_protocol")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "upload_protocol", valid_588824
  var valid_588825 = query.getOrDefault("fields")
  valid_588825 = validateParameter(valid_588825, JString, required = false,
                                 default = nil)
  if valid_588825 != nil:
    section.add "fields", valid_588825
  var valid_588826 = query.getOrDefault("pageToken")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "pageToken", valid_588826
  var valid_588827 = query.getOrDefault("quotaUser")
  valid_588827 = validateParameter(valid_588827, JString, required = false,
                                 default = nil)
  if valid_588827 != nil:
    section.add "quotaUser", valid_588827
  var valid_588841 = query.getOrDefault("alt")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = newJString("json"))
  if valid_588841 != nil:
    section.add "alt", valid_588841
  var valid_588842 = query.getOrDefault("customerId")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "customerId", valid_588842
  var valid_588843 = query.getOrDefault("oauth_token")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "oauth_token", valid_588843
  var valid_588844 = query.getOrDefault("callback")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "callback", valid_588844
  var valid_588845 = query.getOrDefault("access_token")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "access_token", valid_588845
  var valid_588846 = query.getOrDefault("uploadType")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = nil)
  if valid_588846 != nil:
    section.add "uploadType", valid_588846
  var valid_588847 = query.getOrDefault("orderBy")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = nil)
  if valid_588847 != nil:
    section.add "orderBy", valid_588847
  var valid_588848 = query.getOrDefault("key")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "key", valid_588848
  var valid_588849 = query.getOrDefault("$.xgafv")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = newJString("1"))
  if valid_588849 != nil:
    section.add "$.xgafv", valid_588849
  var valid_588850 = query.getOrDefault("pageSize")
  valid_588850 = validateParameter(valid_588850, JInt, required = false, default = nil)
  if valid_588850 != nil:
    section.add "pageSize", valid_588850
  var valid_588851 = query.getOrDefault("prettyPrint")
  valid_588851 = validateParameter(valid_588851, JBool, required = false,
                                 default = newJBool(true))
  if valid_588851 != nil:
    section.add "prettyPrint", valid_588851
  var valid_588852 = query.getOrDefault("filter")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "filter", valid_588852
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588875: Call_AlertcenterAlertsList_588710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the alerts.
  ## 
  let valid = call_588875.validator(path, query, header, formData, body)
  let scheme = call_588875.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588875.url(scheme.get, call_588875.host, call_588875.base,
                         call_588875.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588875, url, valid)

proc call*(call_588946: Call_AlertcenterAlertsList_588710;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; customerId: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## alertcenterAlertsList
  ## Lists the alerts.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. A token identifying a page of results the server should return.
  ## If empty, a new iteration is started. To continue an iteration, pass in
  ## the value from the previous ListAlertsResponse's
  ## next_page_token field.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alerts are associated with.
  ## Inferred from the caller identity if not provided.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: string
  ##          : Optional. The sort order of the list results.
  ## If not specified results may be returned in arbitrary order.
  ## You can sort the results in descending order based on the creation
  ## timestamp using `order_by="create_time desc"`.
  ## Currently, supported sorting are `create_time asc`, `create_time desc`,
  ## `update_time desc`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The requested page size. Server may return fewer items than
  ## requested. If unspecified, server picks an appropriate default.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. A query string for filtering alert results.
  ## For more details, see [Query
  ## filters](/admin-sdk/alertcenter/guides/query-filters) and [Supported
  ## query filter
  ## fields](/admin-sdk/alertcenter/reference/filter-fields#alerts.list).
  var query_588947 = newJObject()
  add(query_588947, "upload_protocol", newJString(uploadProtocol))
  add(query_588947, "fields", newJString(fields))
  add(query_588947, "pageToken", newJString(pageToken))
  add(query_588947, "quotaUser", newJString(quotaUser))
  add(query_588947, "alt", newJString(alt))
  add(query_588947, "customerId", newJString(customerId))
  add(query_588947, "oauth_token", newJString(oauthToken))
  add(query_588947, "callback", newJString(callback))
  add(query_588947, "access_token", newJString(accessToken))
  add(query_588947, "uploadType", newJString(uploadType))
  add(query_588947, "orderBy", newJString(orderBy))
  add(query_588947, "key", newJString(key))
  add(query_588947, "$.xgafv", newJString(Xgafv))
  add(query_588947, "pageSize", newJInt(pageSize))
  add(query_588947, "prettyPrint", newJBool(prettyPrint))
  add(query_588947, "filter", newJString(filter))
  result = call_588946.call(nil, query_588947, nil, nil, nil)

var alertcenterAlertsList* = Call_AlertcenterAlertsList_588710(
    name: "alertcenterAlertsList", meth: HttpMethod.HttpGet,
    host: "alertcenter.googleapis.com", route: "/v1beta1/alerts",
    validator: validate_AlertcenterAlertsList_588711, base: "/",
    url: url_AlertcenterAlertsList_588712, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsGet_588987 = ref object of OpenApiRestCall_588441
proc url_AlertcenterAlertsGet_588989(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/alerts/"),
               (kind: VariableSegment, value: "alertId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertcenterAlertsGet_588988(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified alert. Attempting to get a nonexistent alert returns
  ## `NOT_FOUND` error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Required. The identifier of the alert to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_589004 = path.getOrDefault("alertId")
  valid_589004 = validateParameter(valid_589004, JString, required = true,
                                 default = nil)
  if valid_589004 != nil:
    section.add "alertId", valid_589004
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert is associated with.
  ## Inferred from the caller identity if not provided.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589005 = query.getOrDefault("upload_protocol")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "upload_protocol", valid_589005
  var valid_589006 = query.getOrDefault("fields")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "fields", valid_589006
  var valid_589007 = query.getOrDefault("quotaUser")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "quotaUser", valid_589007
  var valid_589008 = query.getOrDefault("alt")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = newJString("json"))
  if valid_589008 != nil:
    section.add "alt", valid_589008
  var valid_589009 = query.getOrDefault("customerId")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "customerId", valid_589009
  var valid_589010 = query.getOrDefault("oauth_token")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "oauth_token", valid_589010
  var valid_589011 = query.getOrDefault("callback")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "callback", valid_589011
  var valid_589012 = query.getOrDefault("access_token")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "access_token", valid_589012
  var valid_589013 = query.getOrDefault("uploadType")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "uploadType", valid_589013
  var valid_589014 = query.getOrDefault("key")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "key", valid_589014
  var valid_589015 = query.getOrDefault("$.xgafv")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = newJString("1"))
  if valid_589015 != nil:
    section.add "$.xgafv", valid_589015
  var valid_589016 = query.getOrDefault("prettyPrint")
  valid_589016 = validateParameter(valid_589016, JBool, required = false,
                                 default = newJBool(true))
  if valid_589016 != nil:
    section.add "prettyPrint", valid_589016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589017: Call_AlertcenterAlertsGet_588987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified alert. Attempting to get a nonexistent alert returns
  ## `NOT_FOUND` error.
  ## 
  let valid = call_589017.validator(path, query, header, formData, body)
  let scheme = call_589017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589017.url(scheme.get, call_589017.host, call_589017.base,
                         call_589017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589017, url, valid)

proc call*(call_589018: Call_AlertcenterAlertsGet_588987; alertId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; customerId: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## alertcenterAlertsGet
  ## Gets the specified alert. Attempting to get a nonexistent alert returns
  ## `NOT_FOUND` error.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert is associated with.
  ## Inferred from the caller identity if not provided.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   alertId: string (required)
  ##          : Required. The identifier of the alert to retrieve.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589019 = newJObject()
  var query_589020 = newJObject()
  add(query_589020, "upload_protocol", newJString(uploadProtocol))
  add(query_589020, "fields", newJString(fields))
  add(query_589020, "quotaUser", newJString(quotaUser))
  add(query_589020, "alt", newJString(alt))
  add(query_589020, "customerId", newJString(customerId))
  add(query_589020, "oauth_token", newJString(oauthToken))
  add(query_589020, "callback", newJString(callback))
  add(query_589020, "access_token", newJString(accessToken))
  add(query_589020, "uploadType", newJString(uploadType))
  add(query_589020, "key", newJString(key))
  add(path_589019, "alertId", newJString(alertId))
  add(query_589020, "$.xgafv", newJString(Xgafv))
  add(query_589020, "prettyPrint", newJBool(prettyPrint))
  result = call_589018.call(path_589019, query_589020, nil, nil, nil)

var alertcenterAlertsGet* = Call_AlertcenterAlertsGet_588987(
    name: "alertcenterAlertsGet", meth: HttpMethod.HttpGet,
    host: "alertcenter.googleapis.com", route: "/v1beta1/alerts/{alertId}",
    validator: validate_AlertcenterAlertsGet_588988, base: "/",
    url: url_AlertcenterAlertsGet_588989, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsDelete_589021 = ref object of OpenApiRestCall_588441
proc url_AlertcenterAlertsDelete_589023(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/alerts/"),
               (kind: VariableSegment, value: "alertId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertcenterAlertsDelete_589022(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Marks the specified alert for deletion. An alert that has been marked for
  ## deletion is removed from Alert Center after 30 days.
  ## Marking an alert for deletion has no effect on an alert which has
  ## already been marked for deletion. Attempting to mark a nonexistent alert
  ## for deletion results in a `NOT_FOUND` error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Required. The identifier of the alert to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_589024 = path.getOrDefault("alertId")
  valid_589024 = validateParameter(valid_589024, JString, required = true,
                                 default = nil)
  if valid_589024 != nil:
    section.add "alertId", valid_589024
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert is associated with.
  ## Inferred from the caller identity if not provided.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589025 = query.getOrDefault("upload_protocol")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "upload_protocol", valid_589025
  var valid_589026 = query.getOrDefault("fields")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "fields", valid_589026
  var valid_589027 = query.getOrDefault("quotaUser")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "quotaUser", valid_589027
  var valid_589028 = query.getOrDefault("alt")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = newJString("json"))
  if valid_589028 != nil:
    section.add "alt", valid_589028
  var valid_589029 = query.getOrDefault("customerId")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "customerId", valid_589029
  var valid_589030 = query.getOrDefault("oauth_token")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "oauth_token", valid_589030
  var valid_589031 = query.getOrDefault("callback")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "callback", valid_589031
  var valid_589032 = query.getOrDefault("access_token")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "access_token", valid_589032
  var valid_589033 = query.getOrDefault("uploadType")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "uploadType", valid_589033
  var valid_589034 = query.getOrDefault("key")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "key", valid_589034
  var valid_589035 = query.getOrDefault("$.xgafv")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = newJString("1"))
  if valid_589035 != nil:
    section.add "$.xgafv", valid_589035
  var valid_589036 = query.getOrDefault("prettyPrint")
  valid_589036 = validateParameter(valid_589036, JBool, required = false,
                                 default = newJBool(true))
  if valid_589036 != nil:
    section.add "prettyPrint", valid_589036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589037: Call_AlertcenterAlertsDelete_589021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks the specified alert for deletion. An alert that has been marked for
  ## deletion is removed from Alert Center after 30 days.
  ## Marking an alert for deletion has no effect on an alert which has
  ## already been marked for deletion. Attempting to mark a nonexistent alert
  ## for deletion results in a `NOT_FOUND` error.
  ## 
  let valid = call_589037.validator(path, query, header, formData, body)
  let scheme = call_589037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589037.url(scheme.get, call_589037.host, call_589037.base,
                         call_589037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589037, url, valid)

proc call*(call_589038: Call_AlertcenterAlertsDelete_589021; alertId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; customerId: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## alertcenterAlertsDelete
  ## Marks the specified alert for deletion. An alert that has been marked for
  ## deletion is removed from Alert Center after 30 days.
  ## Marking an alert for deletion has no effect on an alert which has
  ## already been marked for deletion. Attempting to mark a nonexistent alert
  ## for deletion results in a `NOT_FOUND` error.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert is associated with.
  ## Inferred from the caller identity if not provided.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   alertId: string (required)
  ##          : Required. The identifier of the alert to delete.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589039 = newJObject()
  var query_589040 = newJObject()
  add(query_589040, "upload_protocol", newJString(uploadProtocol))
  add(query_589040, "fields", newJString(fields))
  add(query_589040, "quotaUser", newJString(quotaUser))
  add(query_589040, "alt", newJString(alt))
  add(query_589040, "customerId", newJString(customerId))
  add(query_589040, "oauth_token", newJString(oauthToken))
  add(query_589040, "callback", newJString(callback))
  add(query_589040, "access_token", newJString(accessToken))
  add(query_589040, "uploadType", newJString(uploadType))
  add(query_589040, "key", newJString(key))
  add(path_589039, "alertId", newJString(alertId))
  add(query_589040, "$.xgafv", newJString(Xgafv))
  add(query_589040, "prettyPrint", newJBool(prettyPrint))
  result = call_589038.call(path_589039, query_589040, nil, nil, nil)

var alertcenterAlertsDelete* = Call_AlertcenterAlertsDelete_589021(
    name: "alertcenterAlertsDelete", meth: HttpMethod.HttpDelete,
    host: "alertcenter.googleapis.com", route: "/v1beta1/alerts/{alertId}",
    validator: validate_AlertcenterAlertsDelete_589022, base: "/",
    url: url_AlertcenterAlertsDelete_589023, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsFeedbackCreate_589062 = ref object of OpenApiRestCall_588441
proc url_AlertcenterAlertsFeedbackCreate_589064(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/alerts/"),
               (kind: VariableSegment, value: "alertId"),
               (kind: ConstantSegment, value: "/feedback")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertcenterAlertsFeedbackCreate_589063(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates new feedback for an alert. Attempting to create a feedback for
  ## a non-existent alert returns `NOT_FOUND` error. Attempting to create a
  ## feedback for an alert that is marked for deletion returns
  ## `FAILED_PRECONDITION' error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Required. The identifier of the alert this feedback belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_589065 = path.getOrDefault("alertId")
  valid_589065 = validateParameter(valid_589065, JString, required = true,
                                 default = nil)
  if valid_589065 != nil:
    section.add "alertId", valid_589065
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert is associated with.
  ## Inferred from the caller identity if not provided.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589066 = query.getOrDefault("upload_protocol")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "upload_protocol", valid_589066
  var valid_589067 = query.getOrDefault("fields")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "fields", valid_589067
  var valid_589068 = query.getOrDefault("quotaUser")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "quotaUser", valid_589068
  var valid_589069 = query.getOrDefault("alt")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = newJString("json"))
  if valid_589069 != nil:
    section.add "alt", valid_589069
  var valid_589070 = query.getOrDefault("customerId")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "customerId", valid_589070
  var valid_589071 = query.getOrDefault("oauth_token")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "oauth_token", valid_589071
  var valid_589072 = query.getOrDefault("callback")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "callback", valid_589072
  var valid_589073 = query.getOrDefault("access_token")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "access_token", valid_589073
  var valid_589074 = query.getOrDefault("uploadType")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "uploadType", valid_589074
  var valid_589075 = query.getOrDefault("key")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "key", valid_589075
  var valid_589076 = query.getOrDefault("$.xgafv")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = newJString("1"))
  if valid_589076 != nil:
    section.add "$.xgafv", valid_589076
  var valid_589077 = query.getOrDefault("prettyPrint")
  valid_589077 = validateParameter(valid_589077, JBool, required = false,
                                 default = newJBool(true))
  if valid_589077 != nil:
    section.add "prettyPrint", valid_589077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589079: Call_AlertcenterAlertsFeedbackCreate_589062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates new feedback for an alert. Attempting to create a feedback for
  ## a non-existent alert returns `NOT_FOUND` error. Attempting to create a
  ## feedback for an alert that is marked for deletion returns
  ## `FAILED_PRECONDITION' error.
  ## 
  let valid = call_589079.validator(path, query, header, formData, body)
  let scheme = call_589079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589079.url(scheme.get, call_589079.host, call_589079.base,
                         call_589079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589079, url, valid)

proc call*(call_589080: Call_AlertcenterAlertsFeedbackCreate_589062;
          alertId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; customerId: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## alertcenterAlertsFeedbackCreate
  ## Creates new feedback for an alert. Attempting to create a feedback for
  ## a non-existent alert returns `NOT_FOUND` error. Attempting to create a
  ## feedback for an alert that is marked for deletion returns
  ## `FAILED_PRECONDITION' error.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert is associated with.
  ## Inferred from the caller identity if not provided.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   alertId: string (required)
  ##          : Required. The identifier of the alert this feedback belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589081 = newJObject()
  var query_589082 = newJObject()
  var body_589083 = newJObject()
  add(query_589082, "upload_protocol", newJString(uploadProtocol))
  add(query_589082, "fields", newJString(fields))
  add(query_589082, "quotaUser", newJString(quotaUser))
  add(query_589082, "alt", newJString(alt))
  add(query_589082, "customerId", newJString(customerId))
  add(query_589082, "oauth_token", newJString(oauthToken))
  add(query_589082, "callback", newJString(callback))
  add(query_589082, "access_token", newJString(accessToken))
  add(query_589082, "uploadType", newJString(uploadType))
  add(query_589082, "key", newJString(key))
  add(path_589081, "alertId", newJString(alertId))
  add(query_589082, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589083 = body
  add(query_589082, "prettyPrint", newJBool(prettyPrint))
  result = call_589080.call(path_589081, query_589082, nil, nil, body_589083)

var alertcenterAlertsFeedbackCreate* = Call_AlertcenterAlertsFeedbackCreate_589062(
    name: "alertcenterAlertsFeedbackCreate", meth: HttpMethod.HttpPost,
    host: "alertcenter.googleapis.com",
    route: "/v1beta1/alerts/{alertId}/feedback",
    validator: validate_AlertcenterAlertsFeedbackCreate_589063, base: "/",
    url: url_AlertcenterAlertsFeedbackCreate_589064, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsFeedbackList_589041 = ref object of OpenApiRestCall_588441
proc url_AlertcenterAlertsFeedbackList_589043(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/alerts/"),
               (kind: VariableSegment, value: "alertId"),
               (kind: ConstantSegment, value: "/feedback")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertcenterAlertsFeedbackList_589042(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the feedback for an alert. Attempting to list feedbacks for
  ## a non-existent alert returns `NOT_FOUND` error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Required. The alert identifier.
  ## The "-" wildcard could be used to represent all alerts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_589044 = path.getOrDefault("alertId")
  valid_589044 = validateParameter(valid_589044, JString, required = true,
                                 default = nil)
  if valid_589044 != nil:
    section.add "alertId", valid_589044
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert feedback are associated with.
  ## Inferred from the caller identity if not provided.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional. A query string for filtering alert feedback results.
  ## For more details, see [Query
  ## filters](/admin-sdk/alertcenter/guides/query-filters) and [Supported
  ## query filter
  ## fields](/admin-sdk/alertcenter/reference/filter-fields#alerts.feedback.list).
  section = newJObject()
  var valid_589045 = query.getOrDefault("upload_protocol")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "upload_protocol", valid_589045
  var valid_589046 = query.getOrDefault("fields")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "fields", valid_589046
  var valid_589047 = query.getOrDefault("quotaUser")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "quotaUser", valid_589047
  var valid_589048 = query.getOrDefault("alt")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = newJString("json"))
  if valid_589048 != nil:
    section.add "alt", valid_589048
  var valid_589049 = query.getOrDefault("customerId")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "customerId", valid_589049
  var valid_589050 = query.getOrDefault("oauth_token")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "oauth_token", valid_589050
  var valid_589051 = query.getOrDefault("callback")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "callback", valid_589051
  var valid_589052 = query.getOrDefault("access_token")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "access_token", valid_589052
  var valid_589053 = query.getOrDefault("uploadType")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "uploadType", valid_589053
  var valid_589054 = query.getOrDefault("key")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "key", valid_589054
  var valid_589055 = query.getOrDefault("$.xgafv")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = newJString("1"))
  if valid_589055 != nil:
    section.add "$.xgafv", valid_589055
  var valid_589056 = query.getOrDefault("prettyPrint")
  valid_589056 = validateParameter(valid_589056, JBool, required = false,
                                 default = newJBool(true))
  if valid_589056 != nil:
    section.add "prettyPrint", valid_589056
  var valid_589057 = query.getOrDefault("filter")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "filter", valid_589057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589058: Call_AlertcenterAlertsFeedbackList_589041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the feedback for an alert. Attempting to list feedbacks for
  ## a non-existent alert returns `NOT_FOUND` error.
  ## 
  let valid = call_589058.validator(path, query, header, formData, body)
  let scheme = call_589058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589058.url(scheme.get, call_589058.host, call_589058.base,
                         call_589058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589058, url, valid)

proc call*(call_589059: Call_AlertcenterAlertsFeedbackList_589041; alertId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; customerId: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## alertcenterAlertsFeedbackList
  ## Lists all the feedback for an alert. Attempting to list feedbacks for
  ## a non-existent alert returns `NOT_FOUND` error.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert feedback are associated with.
  ## Inferred from the caller identity if not provided.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   alertId: string (required)
  ##          : Required. The alert identifier.
  ## The "-" wildcard could be used to represent all alerts.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. A query string for filtering alert feedback results.
  ## For more details, see [Query
  ## filters](/admin-sdk/alertcenter/guides/query-filters) and [Supported
  ## query filter
  ## fields](/admin-sdk/alertcenter/reference/filter-fields#alerts.feedback.list).
  var path_589060 = newJObject()
  var query_589061 = newJObject()
  add(query_589061, "upload_protocol", newJString(uploadProtocol))
  add(query_589061, "fields", newJString(fields))
  add(query_589061, "quotaUser", newJString(quotaUser))
  add(query_589061, "alt", newJString(alt))
  add(query_589061, "customerId", newJString(customerId))
  add(query_589061, "oauth_token", newJString(oauthToken))
  add(query_589061, "callback", newJString(callback))
  add(query_589061, "access_token", newJString(accessToken))
  add(query_589061, "uploadType", newJString(uploadType))
  add(query_589061, "key", newJString(key))
  add(path_589060, "alertId", newJString(alertId))
  add(query_589061, "$.xgafv", newJString(Xgafv))
  add(query_589061, "prettyPrint", newJBool(prettyPrint))
  add(query_589061, "filter", newJString(filter))
  result = call_589059.call(path_589060, query_589061, nil, nil, nil)

var alertcenterAlertsFeedbackList* = Call_AlertcenterAlertsFeedbackList_589041(
    name: "alertcenterAlertsFeedbackList", meth: HttpMethod.HttpGet,
    host: "alertcenter.googleapis.com",
    route: "/v1beta1/alerts/{alertId}/feedback",
    validator: validate_AlertcenterAlertsFeedbackList_589042, base: "/",
    url: url_AlertcenterAlertsFeedbackList_589043, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsGetMetadata_589084 = ref object of OpenApiRestCall_588441
proc url_AlertcenterAlertsGetMetadata_589086(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/alerts/"),
               (kind: VariableSegment, value: "alertId"),
               (kind: ConstantSegment, value: "/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertcenterAlertsGetMetadata_589085(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the metadata of an alert. Attempting to get metadata for
  ## a non-existent alert returns `NOT_FOUND` error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Required. The identifier of the alert this metadata belongs to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_589087 = path.getOrDefault("alertId")
  valid_589087 = validateParameter(valid_589087, JString, required = true,
                                 default = nil)
  if valid_589087 != nil:
    section.add "alertId", valid_589087
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert metadata is associated with.
  ## Inferred from the caller identity if not provided.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589088 = query.getOrDefault("upload_protocol")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "upload_protocol", valid_589088
  var valid_589089 = query.getOrDefault("fields")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "fields", valid_589089
  var valid_589090 = query.getOrDefault("quotaUser")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "quotaUser", valid_589090
  var valid_589091 = query.getOrDefault("alt")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = newJString("json"))
  if valid_589091 != nil:
    section.add "alt", valid_589091
  var valid_589092 = query.getOrDefault("customerId")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "customerId", valid_589092
  var valid_589093 = query.getOrDefault("oauth_token")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "oauth_token", valid_589093
  var valid_589094 = query.getOrDefault("callback")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "callback", valid_589094
  var valid_589095 = query.getOrDefault("access_token")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "access_token", valid_589095
  var valid_589096 = query.getOrDefault("uploadType")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "uploadType", valid_589096
  var valid_589097 = query.getOrDefault("key")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "key", valid_589097
  var valid_589098 = query.getOrDefault("$.xgafv")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = newJString("1"))
  if valid_589098 != nil:
    section.add "$.xgafv", valid_589098
  var valid_589099 = query.getOrDefault("prettyPrint")
  valid_589099 = validateParameter(valid_589099, JBool, required = false,
                                 default = newJBool(true))
  if valid_589099 != nil:
    section.add "prettyPrint", valid_589099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589100: Call_AlertcenterAlertsGetMetadata_589084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the metadata of an alert. Attempting to get metadata for
  ## a non-existent alert returns `NOT_FOUND` error.
  ## 
  let valid = call_589100.validator(path, query, header, formData, body)
  let scheme = call_589100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589100.url(scheme.get, call_589100.host, call_589100.base,
                         call_589100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589100, url, valid)

proc call*(call_589101: Call_AlertcenterAlertsGetMetadata_589084; alertId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; customerId: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## alertcenterAlertsGetMetadata
  ## Returns the metadata of an alert. Attempting to get metadata for
  ## a non-existent alert returns `NOT_FOUND` error.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert metadata is associated with.
  ## Inferred from the caller identity if not provided.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   alertId: string (required)
  ##          : Required. The identifier of the alert this metadata belongs to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589102 = newJObject()
  var query_589103 = newJObject()
  add(query_589103, "upload_protocol", newJString(uploadProtocol))
  add(query_589103, "fields", newJString(fields))
  add(query_589103, "quotaUser", newJString(quotaUser))
  add(query_589103, "alt", newJString(alt))
  add(query_589103, "customerId", newJString(customerId))
  add(query_589103, "oauth_token", newJString(oauthToken))
  add(query_589103, "callback", newJString(callback))
  add(query_589103, "access_token", newJString(accessToken))
  add(query_589103, "uploadType", newJString(uploadType))
  add(query_589103, "key", newJString(key))
  add(path_589102, "alertId", newJString(alertId))
  add(query_589103, "$.xgafv", newJString(Xgafv))
  add(query_589103, "prettyPrint", newJBool(prettyPrint))
  result = call_589101.call(path_589102, query_589103, nil, nil, nil)

var alertcenterAlertsGetMetadata* = Call_AlertcenterAlertsGetMetadata_589084(
    name: "alertcenterAlertsGetMetadata", meth: HttpMethod.HttpGet,
    host: "alertcenter.googleapis.com",
    route: "/v1beta1/alerts/{alertId}/metadata",
    validator: validate_AlertcenterAlertsGetMetadata_589085, base: "/",
    url: url_AlertcenterAlertsGetMetadata_589086, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsUndelete_589104 = ref object of OpenApiRestCall_588441
proc url_AlertcenterAlertsUndelete_589106(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/alerts/"),
               (kind: VariableSegment, value: "alertId"),
               (kind: ConstantSegment, value: ":undelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertcenterAlertsUndelete_589105(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restores, or "undeletes", an alert that was marked for deletion within the
  ## past 30 days. Attempting to undelete an alert which was marked for deletion
  ## over 30 days ago (which has been removed from the Alert Center database) or
  ## a nonexistent alert returns a `NOT_FOUND` error. Attempting to
  ## undelete an alert which has not been marked for deletion has no effect.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Required. The identifier of the alert to undelete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_589107 = path.getOrDefault("alertId")
  valid_589107 = validateParameter(valid_589107, JString, required = true,
                                 default = nil)
  if valid_589107 != nil:
    section.add "alertId", valid_589107
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589108 = query.getOrDefault("upload_protocol")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "upload_protocol", valid_589108
  var valid_589109 = query.getOrDefault("fields")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "fields", valid_589109
  var valid_589110 = query.getOrDefault("quotaUser")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "quotaUser", valid_589110
  var valid_589111 = query.getOrDefault("alt")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = newJString("json"))
  if valid_589111 != nil:
    section.add "alt", valid_589111
  var valid_589112 = query.getOrDefault("oauth_token")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "oauth_token", valid_589112
  var valid_589113 = query.getOrDefault("callback")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "callback", valid_589113
  var valid_589114 = query.getOrDefault("access_token")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "access_token", valid_589114
  var valid_589115 = query.getOrDefault("uploadType")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "uploadType", valid_589115
  var valid_589116 = query.getOrDefault("key")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "key", valid_589116
  var valid_589117 = query.getOrDefault("$.xgafv")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = newJString("1"))
  if valid_589117 != nil:
    section.add "$.xgafv", valid_589117
  var valid_589118 = query.getOrDefault("prettyPrint")
  valid_589118 = validateParameter(valid_589118, JBool, required = false,
                                 default = newJBool(true))
  if valid_589118 != nil:
    section.add "prettyPrint", valid_589118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589120: Call_AlertcenterAlertsUndelete_589104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores, or "undeletes", an alert that was marked for deletion within the
  ## past 30 days. Attempting to undelete an alert which was marked for deletion
  ## over 30 days ago (which has been removed from the Alert Center database) or
  ## a nonexistent alert returns a `NOT_FOUND` error. Attempting to
  ## undelete an alert which has not been marked for deletion has no effect.
  ## 
  let valid = call_589120.validator(path, query, header, formData, body)
  let scheme = call_589120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589120.url(scheme.get, call_589120.host, call_589120.base,
                         call_589120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589120, url, valid)

proc call*(call_589121: Call_AlertcenterAlertsUndelete_589104; alertId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## alertcenterAlertsUndelete
  ## Restores, or "undeletes", an alert that was marked for deletion within the
  ## past 30 days. Attempting to undelete an alert which was marked for deletion
  ## over 30 days ago (which has been removed from the Alert Center database) or
  ## a nonexistent alert returns a `NOT_FOUND` error. Attempting to
  ## undelete an alert which has not been marked for deletion has no effect.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   alertId: string (required)
  ##          : Required. The identifier of the alert to undelete.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589122 = newJObject()
  var query_589123 = newJObject()
  var body_589124 = newJObject()
  add(query_589123, "upload_protocol", newJString(uploadProtocol))
  add(query_589123, "fields", newJString(fields))
  add(query_589123, "quotaUser", newJString(quotaUser))
  add(query_589123, "alt", newJString(alt))
  add(query_589123, "oauth_token", newJString(oauthToken))
  add(query_589123, "callback", newJString(callback))
  add(query_589123, "access_token", newJString(accessToken))
  add(query_589123, "uploadType", newJString(uploadType))
  add(query_589123, "key", newJString(key))
  add(path_589122, "alertId", newJString(alertId))
  add(query_589123, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589124 = body
  add(query_589123, "prettyPrint", newJBool(prettyPrint))
  result = call_589121.call(path_589122, query_589123, nil, nil, body_589124)

var alertcenterAlertsUndelete* = Call_AlertcenterAlertsUndelete_589104(
    name: "alertcenterAlertsUndelete", meth: HttpMethod.HttpPost,
    host: "alertcenter.googleapis.com",
    route: "/v1beta1/alerts/{alertId}:undelete",
    validator: validate_AlertcenterAlertsUndelete_589105, base: "/",
    url: url_AlertcenterAlertsUndelete_589106, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsBatchDelete_589125 = ref object of OpenApiRestCall_588441
proc url_AlertcenterAlertsBatchDelete_589127(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AlertcenterAlertsBatchDelete_589126(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Performs batch delete operation on alerts.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589128 = query.getOrDefault("upload_protocol")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "upload_protocol", valid_589128
  var valid_589129 = query.getOrDefault("fields")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "fields", valid_589129
  var valid_589130 = query.getOrDefault("quotaUser")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "quotaUser", valid_589130
  var valid_589131 = query.getOrDefault("alt")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = newJString("json"))
  if valid_589131 != nil:
    section.add "alt", valid_589131
  var valid_589132 = query.getOrDefault("oauth_token")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "oauth_token", valid_589132
  var valid_589133 = query.getOrDefault("callback")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "callback", valid_589133
  var valid_589134 = query.getOrDefault("access_token")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "access_token", valid_589134
  var valid_589135 = query.getOrDefault("uploadType")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "uploadType", valid_589135
  var valid_589136 = query.getOrDefault("key")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "key", valid_589136
  var valid_589137 = query.getOrDefault("$.xgafv")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = newJString("1"))
  if valid_589137 != nil:
    section.add "$.xgafv", valid_589137
  var valid_589138 = query.getOrDefault("prettyPrint")
  valid_589138 = validateParameter(valid_589138, JBool, required = false,
                                 default = newJBool(true))
  if valid_589138 != nil:
    section.add "prettyPrint", valid_589138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589140: Call_AlertcenterAlertsBatchDelete_589125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs batch delete operation on alerts.
  ## 
  let valid = call_589140.validator(path, query, header, formData, body)
  let scheme = call_589140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589140.url(scheme.get, call_589140.host, call_589140.base,
                         call_589140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589140, url, valid)

proc call*(call_589141: Call_AlertcenterAlertsBatchDelete_589125;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## alertcenterAlertsBatchDelete
  ## Performs batch delete operation on alerts.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589142 = newJObject()
  var body_589143 = newJObject()
  add(query_589142, "upload_protocol", newJString(uploadProtocol))
  add(query_589142, "fields", newJString(fields))
  add(query_589142, "quotaUser", newJString(quotaUser))
  add(query_589142, "alt", newJString(alt))
  add(query_589142, "oauth_token", newJString(oauthToken))
  add(query_589142, "callback", newJString(callback))
  add(query_589142, "access_token", newJString(accessToken))
  add(query_589142, "uploadType", newJString(uploadType))
  add(query_589142, "key", newJString(key))
  add(query_589142, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589143 = body
  add(query_589142, "prettyPrint", newJBool(prettyPrint))
  result = call_589141.call(nil, query_589142, nil, nil, body_589143)

var alertcenterAlertsBatchDelete* = Call_AlertcenterAlertsBatchDelete_589125(
    name: "alertcenterAlertsBatchDelete", meth: HttpMethod.HttpPost,
    host: "alertcenter.googleapis.com", route: "/v1beta1/alerts:batchDelete",
    validator: validate_AlertcenterAlertsBatchDelete_589126, base: "/",
    url: url_AlertcenterAlertsBatchDelete_589127, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsBatchUndelete_589144 = ref object of OpenApiRestCall_588441
proc url_AlertcenterAlertsBatchUndelete_589146(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AlertcenterAlertsBatchUndelete_589145(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Performs batch undelete operation on alerts.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589147 = query.getOrDefault("upload_protocol")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "upload_protocol", valid_589147
  var valid_589148 = query.getOrDefault("fields")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "fields", valid_589148
  var valid_589149 = query.getOrDefault("quotaUser")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "quotaUser", valid_589149
  var valid_589150 = query.getOrDefault("alt")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = newJString("json"))
  if valid_589150 != nil:
    section.add "alt", valid_589150
  var valid_589151 = query.getOrDefault("oauth_token")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "oauth_token", valid_589151
  var valid_589152 = query.getOrDefault("callback")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "callback", valid_589152
  var valid_589153 = query.getOrDefault("access_token")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "access_token", valid_589153
  var valid_589154 = query.getOrDefault("uploadType")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "uploadType", valid_589154
  var valid_589155 = query.getOrDefault("key")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "key", valid_589155
  var valid_589156 = query.getOrDefault("$.xgafv")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = newJString("1"))
  if valid_589156 != nil:
    section.add "$.xgafv", valid_589156
  var valid_589157 = query.getOrDefault("prettyPrint")
  valid_589157 = validateParameter(valid_589157, JBool, required = false,
                                 default = newJBool(true))
  if valid_589157 != nil:
    section.add "prettyPrint", valid_589157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589159: Call_AlertcenterAlertsBatchUndelete_589144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs batch undelete operation on alerts.
  ## 
  let valid = call_589159.validator(path, query, header, formData, body)
  let scheme = call_589159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589159.url(scheme.get, call_589159.host, call_589159.base,
                         call_589159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589159, url, valid)

proc call*(call_589160: Call_AlertcenterAlertsBatchUndelete_589144;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## alertcenterAlertsBatchUndelete
  ## Performs batch undelete operation on alerts.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589161 = newJObject()
  var body_589162 = newJObject()
  add(query_589161, "upload_protocol", newJString(uploadProtocol))
  add(query_589161, "fields", newJString(fields))
  add(query_589161, "quotaUser", newJString(quotaUser))
  add(query_589161, "alt", newJString(alt))
  add(query_589161, "oauth_token", newJString(oauthToken))
  add(query_589161, "callback", newJString(callback))
  add(query_589161, "access_token", newJString(accessToken))
  add(query_589161, "uploadType", newJString(uploadType))
  add(query_589161, "key", newJString(key))
  add(query_589161, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589162 = body
  add(query_589161, "prettyPrint", newJBool(prettyPrint))
  result = call_589160.call(nil, query_589161, nil, nil, body_589162)

var alertcenterAlertsBatchUndelete* = Call_AlertcenterAlertsBatchUndelete_589144(
    name: "alertcenterAlertsBatchUndelete", meth: HttpMethod.HttpPost,
    host: "alertcenter.googleapis.com", route: "/v1beta1/alerts:batchUndelete",
    validator: validate_AlertcenterAlertsBatchUndelete_589145, base: "/",
    url: url_AlertcenterAlertsBatchUndelete_589146, schemes: {Scheme.Https})
type
  Call_AlertcenterGetSettings_589163 = ref object of OpenApiRestCall_588441
proc url_AlertcenterGetSettings_589165(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AlertcenterGetSettings_589164(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns customer-level settings.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert settings are associated with.
  ## Inferred from the caller identity if not provided.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589166 = query.getOrDefault("upload_protocol")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "upload_protocol", valid_589166
  var valid_589167 = query.getOrDefault("fields")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "fields", valid_589167
  var valid_589168 = query.getOrDefault("quotaUser")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "quotaUser", valid_589168
  var valid_589169 = query.getOrDefault("alt")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = newJString("json"))
  if valid_589169 != nil:
    section.add "alt", valid_589169
  var valid_589170 = query.getOrDefault("customerId")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "customerId", valid_589170
  var valid_589171 = query.getOrDefault("oauth_token")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "oauth_token", valid_589171
  var valid_589172 = query.getOrDefault("callback")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "callback", valid_589172
  var valid_589173 = query.getOrDefault("access_token")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "access_token", valid_589173
  var valid_589174 = query.getOrDefault("uploadType")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "uploadType", valid_589174
  var valid_589175 = query.getOrDefault("key")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "key", valid_589175
  var valid_589176 = query.getOrDefault("$.xgafv")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = newJString("1"))
  if valid_589176 != nil:
    section.add "$.xgafv", valid_589176
  var valid_589177 = query.getOrDefault("prettyPrint")
  valid_589177 = validateParameter(valid_589177, JBool, required = false,
                                 default = newJBool(true))
  if valid_589177 != nil:
    section.add "prettyPrint", valid_589177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589178: Call_AlertcenterGetSettings_589163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns customer-level settings.
  ## 
  let valid = call_589178.validator(path, query, header, formData, body)
  let scheme = call_589178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589178.url(scheme.get, call_589178.host, call_589178.base,
                         call_589178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589178, url, valid)

proc call*(call_589179: Call_AlertcenterGetSettings_589163;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; customerId: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## alertcenterGetSettings
  ## Returns customer-level settings.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert settings are associated with.
  ## Inferred from the caller identity if not provided.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589180 = newJObject()
  add(query_589180, "upload_protocol", newJString(uploadProtocol))
  add(query_589180, "fields", newJString(fields))
  add(query_589180, "quotaUser", newJString(quotaUser))
  add(query_589180, "alt", newJString(alt))
  add(query_589180, "customerId", newJString(customerId))
  add(query_589180, "oauth_token", newJString(oauthToken))
  add(query_589180, "callback", newJString(callback))
  add(query_589180, "access_token", newJString(accessToken))
  add(query_589180, "uploadType", newJString(uploadType))
  add(query_589180, "key", newJString(key))
  add(query_589180, "$.xgafv", newJString(Xgafv))
  add(query_589180, "prettyPrint", newJBool(prettyPrint))
  result = call_589179.call(nil, query_589180, nil, nil, nil)

var alertcenterGetSettings* = Call_AlertcenterGetSettings_589163(
    name: "alertcenterGetSettings", meth: HttpMethod.HttpGet,
    host: "alertcenter.googleapis.com", route: "/v1beta1/settings",
    validator: validate_AlertcenterGetSettings_589164, base: "/",
    url: url_AlertcenterGetSettings_589165, schemes: {Scheme.Https})
type
  Call_AlertcenterUpdateSettings_589181 = ref object of OpenApiRestCall_588441
proc url_AlertcenterUpdateSettings_589183(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AlertcenterUpdateSettings_589182(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the customer-level settings.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   customerId: JString
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert settings are associated with.
  ## Inferred from the caller identity if not provided.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589184 = query.getOrDefault("upload_protocol")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "upload_protocol", valid_589184
  var valid_589185 = query.getOrDefault("fields")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "fields", valid_589185
  var valid_589186 = query.getOrDefault("quotaUser")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "quotaUser", valid_589186
  var valid_589187 = query.getOrDefault("alt")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = newJString("json"))
  if valid_589187 != nil:
    section.add "alt", valid_589187
  var valid_589188 = query.getOrDefault("customerId")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "customerId", valid_589188
  var valid_589189 = query.getOrDefault("oauth_token")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "oauth_token", valid_589189
  var valid_589190 = query.getOrDefault("callback")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "callback", valid_589190
  var valid_589191 = query.getOrDefault("access_token")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "access_token", valid_589191
  var valid_589192 = query.getOrDefault("uploadType")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "uploadType", valid_589192
  var valid_589193 = query.getOrDefault("key")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "key", valid_589193
  var valid_589194 = query.getOrDefault("$.xgafv")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = newJString("1"))
  if valid_589194 != nil:
    section.add "$.xgafv", valid_589194
  var valid_589195 = query.getOrDefault("prettyPrint")
  valid_589195 = validateParameter(valid_589195, JBool, required = false,
                                 default = newJBool(true))
  if valid_589195 != nil:
    section.add "prettyPrint", valid_589195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589197: Call_AlertcenterUpdateSettings_589181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the customer-level settings.
  ## 
  let valid = call_589197.validator(path, query, header, formData, body)
  let scheme = call_589197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589197.url(scheme.get, call_589197.host, call_589197.base,
                         call_589197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589197, url, valid)

proc call*(call_589198: Call_AlertcenterUpdateSettings_589181;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; customerId: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## alertcenterUpdateSettings
  ## Updates the customer-level settings.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   customerId: string
  ##             : Optional. The unique identifier of the G Suite organization account of the
  ## customer the alert settings are associated with.
  ## Inferred from the caller identity if not provided.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589199 = newJObject()
  var body_589200 = newJObject()
  add(query_589199, "upload_protocol", newJString(uploadProtocol))
  add(query_589199, "fields", newJString(fields))
  add(query_589199, "quotaUser", newJString(quotaUser))
  add(query_589199, "alt", newJString(alt))
  add(query_589199, "customerId", newJString(customerId))
  add(query_589199, "oauth_token", newJString(oauthToken))
  add(query_589199, "callback", newJString(callback))
  add(query_589199, "access_token", newJString(accessToken))
  add(query_589199, "uploadType", newJString(uploadType))
  add(query_589199, "key", newJString(key))
  add(query_589199, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589200 = body
  add(query_589199, "prettyPrint", newJBool(prettyPrint))
  result = call_589198.call(nil, query_589199, nil, nil, body_589200)

var alertcenterUpdateSettings* = Call_AlertcenterUpdateSettings_589181(
    name: "alertcenterUpdateSettings", meth: HttpMethod.HttpPatch,
    host: "alertcenter.googleapis.com", route: "/v1beta1/settings",
    validator: validate_AlertcenterUpdateSettings_589182, base: "/",
    url: url_AlertcenterUpdateSettings_589183, schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
