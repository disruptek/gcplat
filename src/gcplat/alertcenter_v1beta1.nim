
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_AlertcenterAlertsList_579677 = ref object of OpenApiRestCall_579408
proc url_AlertcenterAlertsList_579679(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AlertcenterAlertsList_579678(path: JsonNode; query: JsonNode;
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
  var valid_579791 = query.getOrDefault("upload_protocol")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "upload_protocol", valid_579791
  var valid_579792 = query.getOrDefault("fields")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "fields", valid_579792
  var valid_579793 = query.getOrDefault("pageToken")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "pageToken", valid_579793
  var valid_579794 = query.getOrDefault("quotaUser")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "quotaUser", valid_579794
  var valid_579808 = query.getOrDefault("alt")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = newJString("json"))
  if valid_579808 != nil:
    section.add "alt", valid_579808
  var valid_579809 = query.getOrDefault("customerId")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "customerId", valid_579809
  var valid_579810 = query.getOrDefault("oauth_token")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "oauth_token", valid_579810
  var valid_579811 = query.getOrDefault("callback")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "callback", valid_579811
  var valid_579812 = query.getOrDefault("access_token")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "access_token", valid_579812
  var valid_579813 = query.getOrDefault("uploadType")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = nil)
  if valid_579813 != nil:
    section.add "uploadType", valid_579813
  var valid_579814 = query.getOrDefault("orderBy")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = nil)
  if valid_579814 != nil:
    section.add "orderBy", valid_579814
  var valid_579815 = query.getOrDefault("key")
  valid_579815 = validateParameter(valid_579815, JString, required = false,
                                 default = nil)
  if valid_579815 != nil:
    section.add "key", valid_579815
  var valid_579816 = query.getOrDefault("$.xgafv")
  valid_579816 = validateParameter(valid_579816, JString, required = false,
                                 default = newJString("1"))
  if valid_579816 != nil:
    section.add "$.xgafv", valid_579816
  var valid_579817 = query.getOrDefault("pageSize")
  valid_579817 = validateParameter(valid_579817, JInt, required = false, default = nil)
  if valid_579817 != nil:
    section.add "pageSize", valid_579817
  var valid_579818 = query.getOrDefault("prettyPrint")
  valid_579818 = validateParameter(valid_579818, JBool, required = false,
                                 default = newJBool(true))
  if valid_579818 != nil:
    section.add "prettyPrint", valid_579818
  var valid_579819 = query.getOrDefault("filter")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "filter", valid_579819
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579842: Call_AlertcenterAlertsList_579677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the alerts.
  ## 
  let valid = call_579842.validator(path, query, header, formData, body)
  let scheme = call_579842.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579842.url(scheme.get, call_579842.host, call_579842.base,
                         call_579842.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579842, url, valid)

proc call*(call_579913: Call_AlertcenterAlertsList_579677;
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
  var query_579914 = newJObject()
  add(query_579914, "upload_protocol", newJString(uploadProtocol))
  add(query_579914, "fields", newJString(fields))
  add(query_579914, "pageToken", newJString(pageToken))
  add(query_579914, "quotaUser", newJString(quotaUser))
  add(query_579914, "alt", newJString(alt))
  add(query_579914, "customerId", newJString(customerId))
  add(query_579914, "oauth_token", newJString(oauthToken))
  add(query_579914, "callback", newJString(callback))
  add(query_579914, "access_token", newJString(accessToken))
  add(query_579914, "uploadType", newJString(uploadType))
  add(query_579914, "orderBy", newJString(orderBy))
  add(query_579914, "key", newJString(key))
  add(query_579914, "$.xgafv", newJString(Xgafv))
  add(query_579914, "pageSize", newJInt(pageSize))
  add(query_579914, "prettyPrint", newJBool(prettyPrint))
  add(query_579914, "filter", newJString(filter))
  result = call_579913.call(nil, query_579914, nil, nil, nil)

var alertcenterAlertsList* = Call_AlertcenterAlertsList_579677(
    name: "alertcenterAlertsList", meth: HttpMethod.HttpGet,
    host: "alertcenter.googleapis.com", route: "/v1beta1/alerts",
    validator: validate_AlertcenterAlertsList_579678, base: "/",
    url: url_AlertcenterAlertsList_579679, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsGet_579954 = ref object of OpenApiRestCall_579408
proc url_AlertcenterAlertsGet_579956(protocol: Scheme; host: string; base: string;
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

proc validate_AlertcenterAlertsGet_579955(path: JsonNode; query: JsonNode;
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
  var valid_579971 = path.getOrDefault("alertId")
  valid_579971 = validateParameter(valid_579971, JString, required = true,
                                 default = nil)
  if valid_579971 != nil:
    section.add "alertId", valid_579971
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
  var valid_579972 = query.getOrDefault("upload_protocol")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "upload_protocol", valid_579972
  var valid_579973 = query.getOrDefault("fields")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "fields", valid_579973
  var valid_579974 = query.getOrDefault("quotaUser")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "quotaUser", valid_579974
  var valid_579975 = query.getOrDefault("alt")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = newJString("json"))
  if valid_579975 != nil:
    section.add "alt", valid_579975
  var valid_579976 = query.getOrDefault("customerId")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "customerId", valid_579976
  var valid_579977 = query.getOrDefault("oauth_token")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "oauth_token", valid_579977
  var valid_579978 = query.getOrDefault("callback")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "callback", valid_579978
  var valid_579979 = query.getOrDefault("access_token")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "access_token", valid_579979
  var valid_579980 = query.getOrDefault("uploadType")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "uploadType", valid_579980
  var valid_579981 = query.getOrDefault("key")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "key", valid_579981
  var valid_579982 = query.getOrDefault("$.xgafv")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = newJString("1"))
  if valid_579982 != nil:
    section.add "$.xgafv", valid_579982
  var valid_579983 = query.getOrDefault("prettyPrint")
  valid_579983 = validateParameter(valid_579983, JBool, required = false,
                                 default = newJBool(true))
  if valid_579983 != nil:
    section.add "prettyPrint", valid_579983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579984: Call_AlertcenterAlertsGet_579954; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified alert. Attempting to get a nonexistent alert returns
  ## `NOT_FOUND` error.
  ## 
  let valid = call_579984.validator(path, query, header, formData, body)
  let scheme = call_579984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579984.url(scheme.get, call_579984.host, call_579984.base,
                         call_579984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579984, url, valid)

proc call*(call_579985: Call_AlertcenterAlertsGet_579954; alertId: string;
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
  var path_579986 = newJObject()
  var query_579987 = newJObject()
  add(query_579987, "upload_protocol", newJString(uploadProtocol))
  add(query_579987, "fields", newJString(fields))
  add(query_579987, "quotaUser", newJString(quotaUser))
  add(query_579987, "alt", newJString(alt))
  add(query_579987, "customerId", newJString(customerId))
  add(query_579987, "oauth_token", newJString(oauthToken))
  add(query_579987, "callback", newJString(callback))
  add(query_579987, "access_token", newJString(accessToken))
  add(query_579987, "uploadType", newJString(uploadType))
  add(query_579987, "key", newJString(key))
  add(path_579986, "alertId", newJString(alertId))
  add(query_579987, "$.xgafv", newJString(Xgafv))
  add(query_579987, "prettyPrint", newJBool(prettyPrint))
  result = call_579985.call(path_579986, query_579987, nil, nil, nil)

var alertcenterAlertsGet* = Call_AlertcenterAlertsGet_579954(
    name: "alertcenterAlertsGet", meth: HttpMethod.HttpGet,
    host: "alertcenter.googleapis.com", route: "/v1beta1/alerts/{alertId}",
    validator: validate_AlertcenterAlertsGet_579955, base: "/",
    url: url_AlertcenterAlertsGet_579956, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsDelete_579988 = ref object of OpenApiRestCall_579408
proc url_AlertcenterAlertsDelete_579990(protocol: Scheme; host: string; base: string;
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

proc validate_AlertcenterAlertsDelete_579989(path: JsonNode; query: JsonNode;
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
  var valid_579991 = path.getOrDefault("alertId")
  valid_579991 = validateParameter(valid_579991, JString, required = true,
                                 default = nil)
  if valid_579991 != nil:
    section.add "alertId", valid_579991
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
  var valid_579992 = query.getOrDefault("upload_protocol")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "upload_protocol", valid_579992
  var valid_579993 = query.getOrDefault("fields")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "fields", valid_579993
  var valid_579994 = query.getOrDefault("quotaUser")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "quotaUser", valid_579994
  var valid_579995 = query.getOrDefault("alt")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = newJString("json"))
  if valid_579995 != nil:
    section.add "alt", valid_579995
  var valid_579996 = query.getOrDefault("customerId")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "customerId", valid_579996
  var valid_579997 = query.getOrDefault("oauth_token")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "oauth_token", valid_579997
  var valid_579998 = query.getOrDefault("callback")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "callback", valid_579998
  var valid_579999 = query.getOrDefault("access_token")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "access_token", valid_579999
  var valid_580000 = query.getOrDefault("uploadType")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "uploadType", valid_580000
  var valid_580001 = query.getOrDefault("key")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "key", valid_580001
  var valid_580002 = query.getOrDefault("$.xgafv")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = newJString("1"))
  if valid_580002 != nil:
    section.add "$.xgafv", valid_580002
  var valid_580003 = query.getOrDefault("prettyPrint")
  valid_580003 = validateParameter(valid_580003, JBool, required = false,
                                 default = newJBool(true))
  if valid_580003 != nil:
    section.add "prettyPrint", valid_580003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580004: Call_AlertcenterAlertsDelete_579988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks the specified alert for deletion. An alert that has been marked for
  ## deletion is removed from Alert Center after 30 days.
  ## Marking an alert for deletion has no effect on an alert which has
  ## already been marked for deletion. Attempting to mark a nonexistent alert
  ## for deletion results in a `NOT_FOUND` error.
  ## 
  let valid = call_580004.validator(path, query, header, formData, body)
  let scheme = call_580004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580004.url(scheme.get, call_580004.host, call_580004.base,
                         call_580004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580004, url, valid)

proc call*(call_580005: Call_AlertcenterAlertsDelete_579988; alertId: string;
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
  var path_580006 = newJObject()
  var query_580007 = newJObject()
  add(query_580007, "upload_protocol", newJString(uploadProtocol))
  add(query_580007, "fields", newJString(fields))
  add(query_580007, "quotaUser", newJString(quotaUser))
  add(query_580007, "alt", newJString(alt))
  add(query_580007, "customerId", newJString(customerId))
  add(query_580007, "oauth_token", newJString(oauthToken))
  add(query_580007, "callback", newJString(callback))
  add(query_580007, "access_token", newJString(accessToken))
  add(query_580007, "uploadType", newJString(uploadType))
  add(query_580007, "key", newJString(key))
  add(path_580006, "alertId", newJString(alertId))
  add(query_580007, "$.xgafv", newJString(Xgafv))
  add(query_580007, "prettyPrint", newJBool(prettyPrint))
  result = call_580005.call(path_580006, query_580007, nil, nil, nil)

var alertcenterAlertsDelete* = Call_AlertcenterAlertsDelete_579988(
    name: "alertcenterAlertsDelete", meth: HttpMethod.HttpDelete,
    host: "alertcenter.googleapis.com", route: "/v1beta1/alerts/{alertId}",
    validator: validate_AlertcenterAlertsDelete_579989, base: "/",
    url: url_AlertcenterAlertsDelete_579990, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsFeedbackCreate_580029 = ref object of OpenApiRestCall_579408
proc url_AlertcenterAlertsFeedbackCreate_580031(protocol: Scheme; host: string;
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

proc validate_AlertcenterAlertsFeedbackCreate_580030(path: JsonNode;
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
  var valid_580032 = path.getOrDefault("alertId")
  valid_580032 = validateParameter(valid_580032, JString, required = true,
                                 default = nil)
  if valid_580032 != nil:
    section.add "alertId", valid_580032
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
  var valid_580033 = query.getOrDefault("upload_protocol")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "upload_protocol", valid_580033
  var valid_580034 = query.getOrDefault("fields")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "fields", valid_580034
  var valid_580035 = query.getOrDefault("quotaUser")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "quotaUser", valid_580035
  var valid_580036 = query.getOrDefault("alt")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("json"))
  if valid_580036 != nil:
    section.add "alt", valid_580036
  var valid_580037 = query.getOrDefault("customerId")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "customerId", valid_580037
  var valid_580038 = query.getOrDefault("oauth_token")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "oauth_token", valid_580038
  var valid_580039 = query.getOrDefault("callback")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "callback", valid_580039
  var valid_580040 = query.getOrDefault("access_token")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "access_token", valid_580040
  var valid_580041 = query.getOrDefault("uploadType")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "uploadType", valid_580041
  var valid_580042 = query.getOrDefault("key")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "key", valid_580042
  var valid_580043 = query.getOrDefault("$.xgafv")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = newJString("1"))
  if valid_580043 != nil:
    section.add "$.xgafv", valid_580043
  var valid_580044 = query.getOrDefault("prettyPrint")
  valid_580044 = validateParameter(valid_580044, JBool, required = false,
                                 default = newJBool(true))
  if valid_580044 != nil:
    section.add "prettyPrint", valid_580044
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

proc call*(call_580046: Call_AlertcenterAlertsFeedbackCreate_580029;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates new feedback for an alert. Attempting to create a feedback for
  ## a non-existent alert returns `NOT_FOUND` error. Attempting to create a
  ## feedback for an alert that is marked for deletion returns
  ## `FAILED_PRECONDITION' error.
  ## 
  let valid = call_580046.validator(path, query, header, formData, body)
  let scheme = call_580046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580046.url(scheme.get, call_580046.host, call_580046.base,
                         call_580046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580046, url, valid)

proc call*(call_580047: Call_AlertcenterAlertsFeedbackCreate_580029;
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
  var path_580048 = newJObject()
  var query_580049 = newJObject()
  var body_580050 = newJObject()
  add(query_580049, "upload_protocol", newJString(uploadProtocol))
  add(query_580049, "fields", newJString(fields))
  add(query_580049, "quotaUser", newJString(quotaUser))
  add(query_580049, "alt", newJString(alt))
  add(query_580049, "customerId", newJString(customerId))
  add(query_580049, "oauth_token", newJString(oauthToken))
  add(query_580049, "callback", newJString(callback))
  add(query_580049, "access_token", newJString(accessToken))
  add(query_580049, "uploadType", newJString(uploadType))
  add(query_580049, "key", newJString(key))
  add(path_580048, "alertId", newJString(alertId))
  add(query_580049, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580050 = body
  add(query_580049, "prettyPrint", newJBool(prettyPrint))
  result = call_580047.call(path_580048, query_580049, nil, nil, body_580050)

var alertcenterAlertsFeedbackCreate* = Call_AlertcenterAlertsFeedbackCreate_580029(
    name: "alertcenterAlertsFeedbackCreate", meth: HttpMethod.HttpPost,
    host: "alertcenter.googleapis.com",
    route: "/v1beta1/alerts/{alertId}/feedback",
    validator: validate_AlertcenterAlertsFeedbackCreate_580030, base: "/",
    url: url_AlertcenterAlertsFeedbackCreate_580031, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsFeedbackList_580008 = ref object of OpenApiRestCall_579408
proc url_AlertcenterAlertsFeedbackList_580010(protocol: Scheme; host: string;
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

proc validate_AlertcenterAlertsFeedbackList_580009(path: JsonNode; query: JsonNode;
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
  var valid_580011 = path.getOrDefault("alertId")
  valid_580011 = validateParameter(valid_580011, JString, required = true,
                                 default = nil)
  if valid_580011 != nil:
    section.add "alertId", valid_580011
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
  var valid_580012 = query.getOrDefault("upload_protocol")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "upload_protocol", valid_580012
  var valid_580013 = query.getOrDefault("fields")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "fields", valid_580013
  var valid_580014 = query.getOrDefault("quotaUser")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "quotaUser", valid_580014
  var valid_580015 = query.getOrDefault("alt")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = newJString("json"))
  if valid_580015 != nil:
    section.add "alt", valid_580015
  var valid_580016 = query.getOrDefault("customerId")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "customerId", valid_580016
  var valid_580017 = query.getOrDefault("oauth_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "oauth_token", valid_580017
  var valid_580018 = query.getOrDefault("callback")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "callback", valid_580018
  var valid_580019 = query.getOrDefault("access_token")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "access_token", valid_580019
  var valid_580020 = query.getOrDefault("uploadType")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "uploadType", valid_580020
  var valid_580021 = query.getOrDefault("key")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "key", valid_580021
  var valid_580022 = query.getOrDefault("$.xgafv")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = newJString("1"))
  if valid_580022 != nil:
    section.add "$.xgafv", valid_580022
  var valid_580023 = query.getOrDefault("prettyPrint")
  valid_580023 = validateParameter(valid_580023, JBool, required = false,
                                 default = newJBool(true))
  if valid_580023 != nil:
    section.add "prettyPrint", valid_580023
  var valid_580024 = query.getOrDefault("filter")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "filter", valid_580024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580025: Call_AlertcenterAlertsFeedbackList_580008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the feedback for an alert. Attempting to list feedbacks for
  ## a non-existent alert returns `NOT_FOUND` error.
  ## 
  let valid = call_580025.validator(path, query, header, formData, body)
  let scheme = call_580025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580025.url(scheme.get, call_580025.host, call_580025.base,
                         call_580025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580025, url, valid)

proc call*(call_580026: Call_AlertcenterAlertsFeedbackList_580008; alertId: string;
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
  var path_580027 = newJObject()
  var query_580028 = newJObject()
  add(query_580028, "upload_protocol", newJString(uploadProtocol))
  add(query_580028, "fields", newJString(fields))
  add(query_580028, "quotaUser", newJString(quotaUser))
  add(query_580028, "alt", newJString(alt))
  add(query_580028, "customerId", newJString(customerId))
  add(query_580028, "oauth_token", newJString(oauthToken))
  add(query_580028, "callback", newJString(callback))
  add(query_580028, "access_token", newJString(accessToken))
  add(query_580028, "uploadType", newJString(uploadType))
  add(query_580028, "key", newJString(key))
  add(path_580027, "alertId", newJString(alertId))
  add(query_580028, "$.xgafv", newJString(Xgafv))
  add(query_580028, "prettyPrint", newJBool(prettyPrint))
  add(query_580028, "filter", newJString(filter))
  result = call_580026.call(path_580027, query_580028, nil, nil, nil)

var alertcenterAlertsFeedbackList* = Call_AlertcenterAlertsFeedbackList_580008(
    name: "alertcenterAlertsFeedbackList", meth: HttpMethod.HttpGet,
    host: "alertcenter.googleapis.com",
    route: "/v1beta1/alerts/{alertId}/feedback",
    validator: validate_AlertcenterAlertsFeedbackList_580009, base: "/",
    url: url_AlertcenterAlertsFeedbackList_580010, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsGetMetadata_580051 = ref object of OpenApiRestCall_579408
proc url_AlertcenterAlertsGetMetadata_580053(protocol: Scheme; host: string;
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

proc validate_AlertcenterAlertsGetMetadata_580052(path: JsonNode; query: JsonNode;
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
  var valid_580054 = path.getOrDefault("alertId")
  valid_580054 = validateParameter(valid_580054, JString, required = true,
                                 default = nil)
  if valid_580054 != nil:
    section.add "alertId", valid_580054
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
  var valid_580055 = query.getOrDefault("upload_protocol")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "upload_protocol", valid_580055
  var valid_580056 = query.getOrDefault("fields")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "fields", valid_580056
  var valid_580057 = query.getOrDefault("quotaUser")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "quotaUser", valid_580057
  var valid_580058 = query.getOrDefault("alt")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = newJString("json"))
  if valid_580058 != nil:
    section.add "alt", valid_580058
  var valid_580059 = query.getOrDefault("customerId")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "customerId", valid_580059
  var valid_580060 = query.getOrDefault("oauth_token")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "oauth_token", valid_580060
  var valid_580061 = query.getOrDefault("callback")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "callback", valid_580061
  var valid_580062 = query.getOrDefault("access_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "access_token", valid_580062
  var valid_580063 = query.getOrDefault("uploadType")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "uploadType", valid_580063
  var valid_580064 = query.getOrDefault("key")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "key", valid_580064
  var valid_580065 = query.getOrDefault("$.xgafv")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = newJString("1"))
  if valid_580065 != nil:
    section.add "$.xgafv", valid_580065
  var valid_580066 = query.getOrDefault("prettyPrint")
  valid_580066 = validateParameter(valid_580066, JBool, required = false,
                                 default = newJBool(true))
  if valid_580066 != nil:
    section.add "prettyPrint", valid_580066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580067: Call_AlertcenterAlertsGetMetadata_580051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the metadata of an alert. Attempting to get metadata for
  ## a non-existent alert returns `NOT_FOUND` error.
  ## 
  let valid = call_580067.validator(path, query, header, formData, body)
  let scheme = call_580067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580067.url(scheme.get, call_580067.host, call_580067.base,
                         call_580067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580067, url, valid)

proc call*(call_580068: Call_AlertcenterAlertsGetMetadata_580051; alertId: string;
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
  var path_580069 = newJObject()
  var query_580070 = newJObject()
  add(query_580070, "upload_protocol", newJString(uploadProtocol))
  add(query_580070, "fields", newJString(fields))
  add(query_580070, "quotaUser", newJString(quotaUser))
  add(query_580070, "alt", newJString(alt))
  add(query_580070, "customerId", newJString(customerId))
  add(query_580070, "oauth_token", newJString(oauthToken))
  add(query_580070, "callback", newJString(callback))
  add(query_580070, "access_token", newJString(accessToken))
  add(query_580070, "uploadType", newJString(uploadType))
  add(query_580070, "key", newJString(key))
  add(path_580069, "alertId", newJString(alertId))
  add(query_580070, "$.xgafv", newJString(Xgafv))
  add(query_580070, "prettyPrint", newJBool(prettyPrint))
  result = call_580068.call(path_580069, query_580070, nil, nil, nil)

var alertcenterAlertsGetMetadata* = Call_AlertcenterAlertsGetMetadata_580051(
    name: "alertcenterAlertsGetMetadata", meth: HttpMethod.HttpGet,
    host: "alertcenter.googleapis.com",
    route: "/v1beta1/alerts/{alertId}/metadata",
    validator: validate_AlertcenterAlertsGetMetadata_580052, base: "/",
    url: url_AlertcenterAlertsGetMetadata_580053, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsUndelete_580071 = ref object of OpenApiRestCall_579408
proc url_AlertcenterAlertsUndelete_580073(protocol: Scheme; host: string;
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

proc validate_AlertcenterAlertsUndelete_580072(path: JsonNode; query: JsonNode;
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
  var valid_580074 = path.getOrDefault("alertId")
  valid_580074 = validateParameter(valid_580074, JString, required = true,
                                 default = nil)
  if valid_580074 != nil:
    section.add "alertId", valid_580074
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
  var valid_580075 = query.getOrDefault("upload_protocol")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "upload_protocol", valid_580075
  var valid_580076 = query.getOrDefault("fields")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "fields", valid_580076
  var valid_580077 = query.getOrDefault("quotaUser")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "quotaUser", valid_580077
  var valid_580078 = query.getOrDefault("alt")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = newJString("json"))
  if valid_580078 != nil:
    section.add "alt", valid_580078
  var valid_580079 = query.getOrDefault("oauth_token")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "oauth_token", valid_580079
  var valid_580080 = query.getOrDefault("callback")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "callback", valid_580080
  var valid_580081 = query.getOrDefault("access_token")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "access_token", valid_580081
  var valid_580082 = query.getOrDefault("uploadType")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "uploadType", valid_580082
  var valid_580083 = query.getOrDefault("key")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "key", valid_580083
  var valid_580084 = query.getOrDefault("$.xgafv")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = newJString("1"))
  if valid_580084 != nil:
    section.add "$.xgafv", valid_580084
  var valid_580085 = query.getOrDefault("prettyPrint")
  valid_580085 = validateParameter(valid_580085, JBool, required = false,
                                 default = newJBool(true))
  if valid_580085 != nil:
    section.add "prettyPrint", valid_580085
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

proc call*(call_580087: Call_AlertcenterAlertsUndelete_580071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores, or "undeletes", an alert that was marked for deletion within the
  ## past 30 days. Attempting to undelete an alert which was marked for deletion
  ## over 30 days ago (which has been removed from the Alert Center database) or
  ## a nonexistent alert returns a `NOT_FOUND` error. Attempting to
  ## undelete an alert which has not been marked for deletion has no effect.
  ## 
  let valid = call_580087.validator(path, query, header, formData, body)
  let scheme = call_580087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580087.url(scheme.get, call_580087.host, call_580087.base,
                         call_580087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580087, url, valid)

proc call*(call_580088: Call_AlertcenterAlertsUndelete_580071; alertId: string;
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
  var path_580089 = newJObject()
  var query_580090 = newJObject()
  var body_580091 = newJObject()
  add(query_580090, "upload_protocol", newJString(uploadProtocol))
  add(query_580090, "fields", newJString(fields))
  add(query_580090, "quotaUser", newJString(quotaUser))
  add(query_580090, "alt", newJString(alt))
  add(query_580090, "oauth_token", newJString(oauthToken))
  add(query_580090, "callback", newJString(callback))
  add(query_580090, "access_token", newJString(accessToken))
  add(query_580090, "uploadType", newJString(uploadType))
  add(query_580090, "key", newJString(key))
  add(path_580089, "alertId", newJString(alertId))
  add(query_580090, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580091 = body
  add(query_580090, "prettyPrint", newJBool(prettyPrint))
  result = call_580088.call(path_580089, query_580090, nil, nil, body_580091)

var alertcenterAlertsUndelete* = Call_AlertcenterAlertsUndelete_580071(
    name: "alertcenterAlertsUndelete", meth: HttpMethod.HttpPost,
    host: "alertcenter.googleapis.com",
    route: "/v1beta1/alerts/{alertId}:undelete",
    validator: validate_AlertcenterAlertsUndelete_580072, base: "/",
    url: url_AlertcenterAlertsUndelete_580073, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsBatchDelete_580092 = ref object of OpenApiRestCall_579408
proc url_AlertcenterAlertsBatchDelete_580094(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AlertcenterAlertsBatchDelete_580093(path: JsonNode; query: JsonNode;
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
  var valid_580095 = query.getOrDefault("upload_protocol")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "upload_protocol", valid_580095
  var valid_580096 = query.getOrDefault("fields")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "fields", valid_580096
  var valid_580097 = query.getOrDefault("quotaUser")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "quotaUser", valid_580097
  var valid_580098 = query.getOrDefault("alt")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = newJString("json"))
  if valid_580098 != nil:
    section.add "alt", valid_580098
  var valid_580099 = query.getOrDefault("oauth_token")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "oauth_token", valid_580099
  var valid_580100 = query.getOrDefault("callback")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "callback", valid_580100
  var valid_580101 = query.getOrDefault("access_token")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "access_token", valid_580101
  var valid_580102 = query.getOrDefault("uploadType")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "uploadType", valid_580102
  var valid_580103 = query.getOrDefault("key")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "key", valid_580103
  var valid_580104 = query.getOrDefault("$.xgafv")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = newJString("1"))
  if valid_580104 != nil:
    section.add "$.xgafv", valid_580104
  var valid_580105 = query.getOrDefault("prettyPrint")
  valid_580105 = validateParameter(valid_580105, JBool, required = false,
                                 default = newJBool(true))
  if valid_580105 != nil:
    section.add "prettyPrint", valid_580105
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

proc call*(call_580107: Call_AlertcenterAlertsBatchDelete_580092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs batch delete operation on alerts.
  ## 
  let valid = call_580107.validator(path, query, header, formData, body)
  let scheme = call_580107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580107.url(scheme.get, call_580107.host, call_580107.base,
                         call_580107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580107, url, valid)

proc call*(call_580108: Call_AlertcenterAlertsBatchDelete_580092;
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
  var query_580109 = newJObject()
  var body_580110 = newJObject()
  add(query_580109, "upload_protocol", newJString(uploadProtocol))
  add(query_580109, "fields", newJString(fields))
  add(query_580109, "quotaUser", newJString(quotaUser))
  add(query_580109, "alt", newJString(alt))
  add(query_580109, "oauth_token", newJString(oauthToken))
  add(query_580109, "callback", newJString(callback))
  add(query_580109, "access_token", newJString(accessToken))
  add(query_580109, "uploadType", newJString(uploadType))
  add(query_580109, "key", newJString(key))
  add(query_580109, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580110 = body
  add(query_580109, "prettyPrint", newJBool(prettyPrint))
  result = call_580108.call(nil, query_580109, nil, nil, body_580110)

var alertcenterAlertsBatchDelete* = Call_AlertcenterAlertsBatchDelete_580092(
    name: "alertcenterAlertsBatchDelete", meth: HttpMethod.HttpPost,
    host: "alertcenter.googleapis.com", route: "/v1beta1/alerts:batchDelete",
    validator: validate_AlertcenterAlertsBatchDelete_580093, base: "/",
    url: url_AlertcenterAlertsBatchDelete_580094, schemes: {Scheme.Https})
type
  Call_AlertcenterAlertsBatchUndelete_580111 = ref object of OpenApiRestCall_579408
proc url_AlertcenterAlertsBatchUndelete_580113(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AlertcenterAlertsBatchUndelete_580112(path: JsonNode;
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
  var valid_580114 = query.getOrDefault("upload_protocol")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "upload_protocol", valid_580114
  var valid_580115 = query.getOrDefault("fields")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "fields", valid_580115
  var valid_580116 = query.getOrDefault("quotaUser")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "quotaUser", valid_580116
  var valid_580117 = query.getOrDefault("alt")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = newJString("json"))
  if valid_580117 != nil:
    section.add "alt", valid_580117
  var valid_580118 = query.getOrDefault("oauth_token")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "oauth_token", valid_580118
  var valid_580119 = query.getOrDefault("callback")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "callback", valid_580119
  var valid_580120 = query.getOrDefault("access_token")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "access_token", valid_580120
  var valid_580121 = query.getOrDefault("uploadType")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "uploadType", valid_580121
  var valid_580122 = query.getOrDefault("key")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "key", valid_580122
  var valid_580123 = query.getOrDefault("$.xgafv")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = newJString("1"))
  if valid_580123 != nil:
    section.add "$.xgafv", valid_580123
  var valid_580124 = query.getOrDefault("prettyPrint")
  valid_580124 = validateParameter(valid_580124, JBool, required = false,
                                 default = newJBool(true))
  if valid_580124 != nil:
    section.add "prettyPrint", valid_580124
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

proc call*(call_580126: Call_AlertcenterAlertsBatchUndelete_580111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs batch undelete operation on alerts.
  ## 
  let valid = call_580126.validator(path, query, header, formData, body)
  let scheme = call_580126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580126.url(scheme.get, call_580126.host, call_580126.base,
                         call_580126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580126, url, valid)

proc call*(call_580127: Call_AlertcenterAlertsBatchUndelete_580111;
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
  var query_580128 = newJObject()
  var body_580129 = newJObject()
  add(query_580128, "upload_protocol", newJString(uploadProtocol))
  add(query_580128, "fields", newJString(fields))
  add(query_580128, "quotaUser", newJString(quotaUser))
  add(query_580128, "alt", newJString(alt))
  add(query_580128, "oauth_token", newJString(oauthToken))
  add(query_580128, "callback", newJString(callback))
  add(query_580128, "access_token", newJString(accessToken))
  add(query_580128, "uploadType", newJString(uploadType))
  add(query_580128, "key", newJString(key))
  add(query_580128, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580129 = body
  add(query_580128, "prettyPrint", newJBool(prettyPrint))
  result = call_580127.call(nil, query_580128, nil, nil, body_580129)

var alertcenterAlertsBatchUndelete* = Call_AlertcenterAlertsBatchUndelete_580111(
    name: "alertcenterAlertsBatchUndelete", meth: HttpMethod.HttpPost,
    host: "alertcenter.googleapis.com", route: "/v1beta1/alerts:batchUndelete",
    validator: validate_AlertcenterAlertsBatchUndelete_580112, base: "/",
    url: url_AlertcenterAlertsBatchUndelete_580113, schemes: {Scheme.Https})
type
  Call_AlertcenterGetSettings_580130 = ref object of OpenApiRestCall_579408
proc url_AlertcenterGetSettings_580132(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AlertcenterGetSettings_580131(path: JsonNode; query: JsonNode;
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
  var valid_580133 = query.getOrDefault("upload_protocol")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "upload_protocol", valid_580133
  var valid_580134 = query.getOrDefault("fields")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "fields", valid_580134
  var valid_580135 = query.getOrDefault("quotaUser")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "quotaUser", valid_580135
  var valid_580136 = query.getOrDefault("alt")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = newJString("json"))
  if valid_580136 != nil:
    section.add "alt", valid_580136
  var valid_580137 = query.getOrDefault("customerId")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "customerId", valid_580137
  var valid_580138 = query.getOrDefault("oauth_token")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "oauth_token", valid_580138
  var valid_580139 = query.getOrDefault("callback")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "callback", valid_580139
  var valid_580140 = query.getOrDefault("access_token")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "access_token", valid_580140
  var valid_580141 = query.getOrDefault("uploadType")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "uploadType", valid_580141
  var valid_580142 = query.getOrDefault("key")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "key", valid_580142
  var valid_580143 = query.getOrDefault("$.xgafv")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = newJString("1"))
  if valid_580143 != nil:
    section.add "$.xgafv", valid_580143
  var valid_580144 = query.getOrDefault("prettyPrint")
  valid_580144 = validateParameter(valid_580144, JBool, required = false,
                                 default = newJBool(true))
  if valid_580144 != nil:
    section.add "prettyPrint", valid_580144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580145: Call_AlertcenterGetSettings_580130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns customer-level settings.
  ## 
  let valid = call_580145.validator(path, query, header, formData, body)
  let scheme = call_580145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580145.url(scheme.get, call_580145.host, call_580145.base,
                         call_580145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580145, url, valid)

proc call*(call_580146: Call_AlertcenterGetSettings_580130;
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
  var query_580147 = newJObject()
  add(query_580147, "upload_protocol", newJString(uploadProtocol))
  add(query_580147, "fields", newJString(fields))
  add(query_580147, "quotaUser", newJString(quotaUser))
  add(query_580147, "alt", newJString(alt))
  add(query_580147, "customerId", newJString(customerId))
  add(query_580147, "oauth_token", newJString(oauthToken))
  add(query_580147, "callback", newJString(callback))
  add(query_580147, "access_token", newJString(accessToken))
  add(query_580147, "uploadType", newJString(uploadType))
  add(query_580147, "key", newJString(key))
  add(query_580147, "$.xgafv", newJString(Xgafv))
  add(query_580147, "prettyPrint", newJBool(prettyPrint))
  result = call_580146.call(nil, query_580147, nil, nil, nil)

var alertcenterGetSettings* = Call_AlertcenterGetSettings_580130(
    name: "alertcenterGetSettings", meth: HttpMethod.HttpGet,
    host: "alertcenter.googleapis.com", route: "/v1beta1/settings",
    validator: validate_AlertcenterGetSettings_580131, base: "/",
    url: url_AlertcenterGetSettings_580132, schemes: {Scheme.Https})
type
  Call_AlertcenterUpdateSettings_580148 = ref object of OpenApiRestCall_579408
proc url_AlertcenterUpdateSettings_580150(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AlertcenterUpdateSettings_580149(path: JsonNode; query: JsonNode;
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
  var valid_580151 = query.getOrDefault("upload_protocol")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "upload_protocol", valid_580151
  var valid_580152 = query.getOrDefault("fields")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "fields", valid_580152
  var valid_580153 = query.getOrDefault("quotaUser")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "quotaUser", valid_580153
  var valid_580154 = query.getOrDefault("alt")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = newJString("json"))
  if valid_580154 != nil:
    section.add "alt", valid_580154
  var valid_580155 = query.getOrDefault("customerId")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "customerId", valid_580155
  var valid_580156 = query.getOrDefault("oauth_token")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "oauth_token", valid_580156
  var valid_580157 = query.getOrDefault("callback")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "callback", valid_580157
  var valid_580158 = query.getOrDefault("access_token")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "access_token", valid_580158
  var valid_580159 = query.getOrDefault("uploadType")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "uploadType", valid_580159
  var valid_580160 = query.getOrDefault("key")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "key", valid_580160
  var valid_580161 = query.getOrDefault("$.xgafv")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = newJString("1"))
  if valid_580161 != nil:
    section.add "$.xgafv", valid_580161
  var valid_580162 = query.getOrDefault("prettyPrint")
  valid_580162 = validateParameter(valid_580162, JBool, required = false,
                                 default = newJBool(true))
  if valid_580162 != nil:
    section.add "prettyPrint", valid_580162
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

proc call*(call_580164: Call_AlertcenterUpdateSettings_580148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the customer-level settings.
  ## 
  let valid = call_580164.validator(path, query, header, formData, body)
  let scheme = call_580164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580164.url(scheme.get, call_580164.host, call_580164.base,
                         call_580164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580164, url, valid)

proc call*(call_580165: Call_AlertcenterUpdateSettings_580148;
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
  var query_580166 = newJObject()
  var body_580167 = newJObject()
  add(query_580166, "upload_protocol", newJString(uploadProtocol))
  add(query_580166, "fields", newJString(fields))
  add(query_580166, "quotaUser", newJString(quotaUser))
  add(query_580166, "alt", newJString(alt))
  add(query_580166, "customerId", newJString(customerId))
  add(query_580166, "oauth_token", newJString(oauthToken))
  add(query_580166, "callback", newJString(callback))
  add(query_580166, "access_token", newJString(accessToken))
  add(query_580166, "uploadType", newJString(uploadType))
  add(query_580166, "key", newJString(key))
  add(query_580166, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580167 = body
  add(query_580166, "prettyPrint", newJBool(prettyPrint))
  result = call_580165.call(nil, query_580166, nil, nil, body_580167)

var alertcenterUpdateSettings* = Call_AlertcenterUpdateSettings_580148(
    name: "alertcenterUpdateSettings", meth: HttpMethod.HttpPatch,
    host: "alertcenter.googleapis.com", route: "/v1beta1/settings",
    validator: validate_AlertcenterUpdateSettings_580149, base: "/",
    url: url_AlertcenterUpdateSettings_580150, schemes: {Scheme.Https})
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
