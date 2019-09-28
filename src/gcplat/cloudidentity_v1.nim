
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Identity
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## API for provisioning and managing identity resources.
## 
## https://cloud.google.com/identity/
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
  gcpServiceName = "cloudidentity"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudidentityGroupsCreate_579953 = ref object of OpenApiRestCall_579408
proc url_CloudidentityGroupsCreate_579955(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsCreate_579954(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Group.
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
  var valid_579956 = query.getOrDefault("upload_protocol")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "upload_protocol", valid_579956
  var valid_579957 = query.getOrDefault("fields")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "fields", valid_579957
  var valid_579958 = query.getOrDefault("quotaUser")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "quotaUser", valid_579958
  var valid_579959 = query.getOrDefault("alt")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = newJString("json"))
  if valid_579959 != nil:
    section.add "alt", valid_579959
  var valid_579960 = query.getOrDefault("oauth_token")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "oauth_token", valid_579960
  var valid_579961 = query.getOrDefault("callback")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "callback", valid_579961
  var valid_579962 = query.getOrDefault("access_token")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "access_token", valid_579962
  var valid_579963 = query.getOrDefault("uploadType")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "uploadType", valid_579963
  var valid_579964 = query.getOrDefault("key")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "key", valid_579964
  var valid_579965 = query.getOrDefault("$.xgafv")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = newJString("1"))
  if valid_579965 != nil:
    section.add "$.xgafv", valid_579965
  var valid_579966 = query.getOrDefault("prettyPrint")
  valid_579966 = validateParameter(valid_579966, JBool, required = false,
                                 default = newJBool(true))
  if valid_579966 != nil:
    section.add "prettyPrint", valid_579966
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

proc call*(call_579968: Call_CloudidentityGroupsCreate_579953; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Group.
  ## 
  let valid = call_579968.validator(path, query, header, formData, body)
  let scheme = call_579968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579968.url(scheme.get, call_579968.host, call_579968.base,
                         call_579968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579968, url, valid)

proc call*(call_579969: Call_CloudidentityGroupsCreate_579953;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudidentityGroupsCreate
  ## Creates a Group.
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
  var query_579970 = newJObject()
  var body_579971 = newJObject()
  add(query_579970, "upload_protocol", newJString(uploadProtocol))
  add(query_579970, "fields", newJString(fields))
  add(query_579970, "quotaUser", newJString(quotaUser))
  add(query_579970, "alt", newJString(alt))
  add(query_579970, "oauth_token", newJString(oauthToken))
  add(query_579970, "callback", newJString(callback))
  add(query_579970, "access_token", newJString(accessToken))
  add(query_579970, "uploadType", newJString(uploadType))
  add(query_579970, "key", newJString(key))
  add(query_579970, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579971 = body
  add(query_579970, "prettyPrint", newJBool(prettyPrint))
  result = call_579969.call(nil, query_579970, nil, nil, body_579971)

var cloudidentityGroupsCreate* = Call_CloudidentityGroupsCreate_579953(
    name: "cloudidentityGroupsCreate", meth: HttpMethod.HttpPost,
    host: "cloudidentity.googleapis.com", route: "/v1/groups",
    validator: validate_CloudidentityGroupsCreate_579954, base: "/",
    url: url_CloudidentityGroupsCreate_579955, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsList_579677 = ref object of OpenApiRestCall_579408
proc url_CloudidentityGroupsList_579679(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsList_579678(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List groups within a customer or a domain.
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
  ##            : The next_page_token value returned from a previous list request, if any.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : Group resource view to be returned. Defaults to [View.BASIC]().
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
  ##   parent: JString
  ##         : `Required`. May be made Optional in the future.
  ## Customer ID to list all groups from.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The default page size is 200 (max 1000) for the BASIC view, and 50
  ## (max 500) for the FULL view.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
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
  var valid_579808 = query.getOrDefault("view")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_579808 != nil:
    section.add "view", valid_579808
  var valid_579809 = query.getOrDefault("alt")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = newJString("json"))
  if valid_579809 != nil:
    section.add "alt", valid_579809
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
  var valid_579814 = query.getOrDefault("parent")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = nil)
  if valid_579814 != nil:
    section.add "parent", valid_579814
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579841: Call_CloudidentityGroupsList_579677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List groups within a customer or a domain.
  ## 
  let valid = call_579841.validator(path, query, header, formData, body)
  let scheme = call_579841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579841.url(scheme.get, call_579841.host, call_579841.base,
                         call_579841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579841, url, valid)

proc call*(call_579912: Call_CloudidentityGroupsList_579677;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; view: string = "VIEW_UNSPECIFIED";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; parent: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## cloudidentityGroupsList
  ## List groups within a customer or a domain.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous list request, if any.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : Group resource view to be returned. Defaults to [View.BASIC]().
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
  ##   parent: string
  ##         : `Required`. May be made Optional in the future.
  ## Customer ID to list all groups from.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The default page size is 200 (max 1000) for the BASIC view, and 50
  ## (max 500) for the FULL view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579913 = newJObject()
  add(query_579913, "upload_protocol", newJString(uploadProtocol))
  add(query_579913, "fields", newJString(fields))
  add(query_579913, "pageToken", newJString(pageToken))
  add(query_579913, "quotaUser", newJString(quotaUser))
  add(query_579913, "view", newJString(view))
  add(query_579913, "alt", newJString(alt))
  add(query_579913, "oauth_token", newJString(oauthToken))
  add(query_579913, "callback", newJString(callback))
  add(query_579913, "access_token", newJString(accessToken))
  add(query_579913, "uploadType", newJString(uploadType))
  add(query_579913, "parent", newJString(parent))
  add(query_579913, "key", newJString(key))
  add(query_579913, "$.xgafv", newJString(Xgafv))
  add(query_579913, "pageSize", newJInt(pageSize))
  add(query_579913, "prettyPrint", newJBool(prettyPrint))
  result = call_579912.call(nil, query_579913, nil, nil, nil)

var cloudidentityGroupsList* = Call_CloudidentityGroupsList_579677(
    name: "cloudidentityGroupsList", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1/groups",
    validator: validate_CloudidentityGroupsList_579678, base: "/",
    url: url_CloudidentityGroupsList_579679, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsLookup_579972 = ref object of OpenApiRestCall_579408
proc url_CloudidentityGroupsLookup_579974(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsLookup_579973(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Group by
  ## its EntityKey.
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
  ##   groupKey.namespace: JString
  ##                     : Namespaces provide isolation for IDs, so an ID only needs to be unique
  ## within its namespace.
  ## 
  ## Namespaces are currently only created as part of IdentitySource creation
  ## from Admin Console. A namespace `"identitysources/{identity_source_id}"` is
  ## created corresponding to every Identity Source `identity_source_id`.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   groupKey.id: JString
  ##              : The ID of the entity within the given namespace. The ID must be unique
  ## within its namespace.
  section = newJObject()
  var valid_579975 = query.getOrDefault("upload_protocol")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "upload_protocol", valid_579975
  var valid_579976 = query.getOrDefault("fields")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "fields", valid_579976
  var valid_579977 = query.getOrDefault("quotaUser")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "quotaUser", valid_579977
  var valid_579978 = query.getOrDefault("alt")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("json"))
  if valid_579978 != nil:
    section.add "alt", valid_579978
  var valid_579979 = query.getOrDefault("oauth_token")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "oauth_token", valid_579979
  var valid_579980 = query.getOrDefault("callback")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "callback", valid_579980
  var valid_579981 = query.getOrDefault("access_token")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "access_token", valid_579981
  var valid_579982 = query.getOrDefault("uploadType")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "uploadType", valid_579982
  var valid_579983 = query.getOrDefault("groupKey.namespace")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "groupKey.namespace", valid_579983
  var valid_579984 = query.getOrDefault("key")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "key", valid_579984
  var valid_579985 = query.getOrDefault("$.xgafv")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = newJString("1"))
  if valid_579985 != nil:
    section.add "$.xgafv", valid_579985
  var valid_579986 = query.getOrDefault("prettyPrint")
  valid_579986 = validateParameter(valid_579986, JBool, required = false,
                                 default = newJBool(true))
  if valid_579986 != nil:
    section.add "prettyPrint", valid_579986
  var valid_579987 = query.getOrDefault("groupKey.id")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "groupKey.id", valid_579987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579988: Call_CloudidentityGroupsLookup_579972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Group by
  ## its EntityKey.
  ## 
  let valid = call_579988.validator(path, query, header, formData, body)
  let scheme = call_579988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579988.url(scheme.get, call_579988.host, call_579988.base,
                         call_579988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579988, url, valid)

proc call*(call_579989: Call_CloudidentityGroupsLookup_579972;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          groupKeyNamespace: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; groupKeyId: string = ""): Recallable =
  ## cloudidentityGroupsLookup
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Group by
  ## its EntityKey.
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
  ##   groupKeyNamespace: string
  ##                    : Namespaces provide isolation for IDs, so an ID only needs to be unique
  ## within its namespace.
  ## 
  ## Namespaces are currently only created as part of IdentitySource creation
  ## from Admin Console. A namespace `"identitysources/{identity_source_id}"` is
  ## created corresponding to every Identity Source `identity_source_id`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   groupKeyId: string
  ##             : The ID of the entity within the given namespace. The ID must be unique
  ## within its namespace.
  var query_579990 = newJObject()
  add(query_579990, "upload_protocol", newJString(uploadProtocol))
  add(query_579990, "fields", newJString(fields))
  add(query_579990, "quotaUser", newJString(quotaUser))
  add(query_579990, "alt", newJString(alt))
  add(query_579990, "oauth_token", newJString(oauthToken))
  add(query_579990, "callback", newJString(callback))
  add(query_579990, "access_token", newJString(accessToken))
  add(query_579990, "uploadType", newJString(uploadType))
  add(query_579990, "groupKey.namespace", newJString(groupKeyNamespace))
  add(query_579990, "key", newJString(key))
  add(query_579990, "$.xgafv", newJString(Xgafv))
  add(query_579990, "prettyPrint", newJBool(prettyPrint))
  add(query_579990, "groupKey.id", newJString(groupKeyId))
  result = call_579989.call(nil, query_579990, nil, nil, nil)

var cloudidentityGroupsLookup* = Call_CloudidentityGroupsLookup_579972(
    name: "cloudidentityGroupsLookup", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1/groups:lookup",
    validator: validate_CloudidentityGroupsLookup_579973, base: "/",
    url: url_CloudidentityGroupsLookup_579974, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsSearch_579991 = ref object of OpenApiRestCall_579408
proc url_CloudidentityGroupsSearch_579993(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsSearch_579992(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Searches for Groups.
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
  ##            : The next_page_token value returned from a previous search request, if any.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : Group resource view to be returned. Defaults to [View.BASIC]().
  ##   alt: JString
  ##      : Data format for response.
  ##   query: JString
  ##        : `Required`. Query string for performing search on groups. Users can search
  ## on parent and label attributes of groups.
  ## EXACT match ('==') is supported on parent, and CONTAINS match ('in') is
  ## supported on labels.
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
  ##   pageSize: JInt
  ##           : The default page size is 200 (max 1000) for the BASIC view, and 50
  ## (max 500) for the FULL view.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579994 = query.getOrDefault("upload_protocol")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "upload_protocol", valid_579994
  var valid_579995 = query.getOrDefault("fields")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "fields", valid_579995
  var valid_579996 = query.getOrDefault("pageToken")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "pageToken", valid_579996
  var valid_579997 = query.getOrDefault("quotaUser")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "quotaUser", valid_579997
  var valid_579998 = query.getOrDefault("view")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_579998 != nil:
    section.add "view", valid_579998
  var valid_579999 = query.getOrDefault("alt")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = newJString("json"))
  if valid_579999 != nil:
    section.add "alt", valid_579999
  var valid_580000 = query.getOrDefault("query")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "query", valid_580000
  var valid_580001 = query.getOrDefault("oauth_token")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "oauth_token", valid_580001
  var valid_580002 = query.getOrDefault("callback")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "callback", valid_580002
  var valid_580003 = query.getOrDefault("access_token")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "access_token", valid_580003
  var valid_580004 = query.getOrDefault("uploadType")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "uploadType", valid_580004
  var valid_580005 = query.getOrDefault("key")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "key", valid_580005
  var valid_580006 = query.getOrDefault("$.xgafv")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = newJString("1"))
  if valid_580006 != nil:
    section.add "$.xgafv", valid_580006
  var valid_580007 = query.getOrDefault("pageSize")
  valid_580007 = validateParameter(valid_580007, JInt, required = false, default = nil)
  if valid_580007 != nil:
    section.add "pageSize", valid_580007
  var valid_580008 = query.getOrDefault("prettyPrint")
  valid_580008 = validateParameter(valid_580008, JBool, required = false,
                                 default = newJBool(true))
  if valid_580008 != nil:
    section.add "prettyPrint", valid_580008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580009: Call_CloudidentityGroupsSearch_579991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for Groups.
  ## 
  let valid = call_580009.validator(path, query, header, formData, body)
  let scheme = call_580009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580009.url(scheme.get, call_580009.host, call_580009.base,
                         call_580009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580009, url, valid)

proc call*(call_580010: Call_CloudidentityGroupsSearch_579991;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; view: string = "VIEW_UNSPECIFIED";
          alt: string = "json"; query: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## cloudidentityGroupsSearch
  ## Searches for Groups.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous search request, if any.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : Group resource view to be returned. Defaults to [View.BASIC]().
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : `Required`. Query string for performing search on groups. Users can search
  ## on parent and label attributes of groups.
  ## EXACT match ('==') is supported on parent, and CONTAINS match ('in') is
  ## supported on labels.
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
  ##   pageSize: int
  ##           : The default page size is 200 (max 1000) for the BASIC view, and 50
  ## (max 500) for the FULL view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580011 = newJObject()
  add(query_580011, "upload_protocol", newJString(uploadProtocol))
  add(query_580011, "fields", newJString(fields))
  add(query_580011, "pageToken", newJString(pageToken))
  add(query_580011, "quotaUser", newJString(quotaUser))
  add(query_580011, "view", newJString(view))
  add(query_580011, "alt", newJString(alt))
  add(query_580011, "query", newJString(query))
  add(query_580011, "oauth_token", newJString(oauthToken))
  add(query_580011, "callback", newJString(callback))
  add(query_580011, "access_token", newJString(accessToken))
  add(query_580011, "uploadType", newJString(uploadType))
  add(query_580011, "key", newJString(key))
  add(query_580011, "$.xgafv", newJString(Xgafv))
  add(query_580011, "pageSize", newJInt(pageSize))
  add(query_580011, "prettyPrint", newJBool(prettyPrint))
  result = call_580010.call(nil, query_580011, nil, nil, nil)

var cloudidentityGroupsSearch* = Call_CloudidentityGroupsSearch_579991(
    name: "cloudidentityGroupsSearch", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1/groups:search",
    validator: validate_CloudidentityGroupsSearch_579992, base: "/",
    url: url_CloudidentityGroupsSearch_579993, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsGet_580012 = ref object of OpenApiRestCall_579408
proc url_CloudidentityGroupsMembershipsGet_580014(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsMembershipsGet_580013(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a Membership.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Membership to be retrieved.
  ## 
  ## Format: `groups/{group_id}/memberships/{member_id}`, where `group_id` is
  ## the unique id assigned to the Group to which Membership belongs to, and
  ## `member_id` is the unique ID assigned to the member.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580029 = path.getOrDefault("name")
  valid_580029 = validateParameter(valid_580029, JString, required = true,
                                 default = nil)
  if valid_580029 != nil:
    section.add "name", valid_580029
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
  var valid_580030 = query.getOrDefault("upload_protocol")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "upload_protocol", valid_580030
  var valid_580031 = query.getOrDefault("fields")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "fields", valid_580031
  var valid_580032 = query.getOrDefault("quotaUser")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "quotaUser", valid_580032
  var valid_580033 = query.getOrDefault("alt")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = newJString("json"))
  if valid_580033 != nil:
    section.add "alt", valid_580033
  var valid_580034 = query.getOrDefault("oauth_token")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "oauth_token", valid_580034
  var valid_580035 = query.getOrDefault("callback")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "callback", valid_580035
  var valid_580036 = query.getOrDefault("access_token")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "access_token", valid_580036
  var valid_580037 = query.getOrDefault("uploadType")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "uploadType", valid_580037
  var valid_580038 = query.getOrDefault("key")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "key", valid_580038
  var valid_580039 = query.getOrDefault("$.xgafv")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = newJString("1"))
  if valid_580039 != nil:
    section.add "$.xgafv", valid_580039
  var valid_580040 = query.getOrDefault("prettyPrint")
  valid_580040 = validateParameter(valid_580040, JBool, required = false,
                                 default = newJBool(true))
  if valid_580040 != nil:
    section.add "prettyPrint", valid_580040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580041: Call_CloudidentityGroupsMembershipsGet_580012;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a Membership.
  ## 
  let valid = call_580041.validator(path, query, header, formData, body)
  let scheme = call_580041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580041.url(scheme.get, call_580041.host, call_580041.base,
                         call_580041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580041, url, valid)

proc call*(call_580042: Call_CloudidentityGroupsMembershipsGet_580012;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudidentityGroupsMembershipsGet
  ## Retrieves a Membership.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Membership to be retrieved.
  ## 
  ## Format: `groups/{group_id}/memberships/{member_id}`, where `group_id` is
  ## the unique id assigned to the Group to which Membership belongs to, and
  ## `member_id` is the unique ID assigned to the member.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580043 = newJObject()
  var query_580044 = newJObject()
  add(query_580044, "upload_protocol", newJString(uploadProtocol))
  add(query_580044, "fields", newJString(fields))
  add(query_580044, "quotaUser", newJString(quotaUser))
  add(path_580043, "name", newJString(name))
  add(query_580044, "alt", newJString(alt))
  add(query_580044, "oauth_token", newJString(oauthToken))
  add(query_580044, "callback", newJString(callback))
  add(query_580044, "access_token", newJString(accessToken))
  add(query_580044, "uploadType", newJString(uploadType))
  add(query_580044, "key", newJString(key))
  add(query_580044, "$.xgafv", newJString(Xgafv))
  add(query_580044, "prettyPrint", newJBool(prettyPrint))
  result = call_580042.call(path_580043, query_580044, nil, nil, nil)

var cloudidentityGroupsMembershipsGet* = Call_CloudidentityGroupsMembershipsGet_580012(
    name: "cloudidentityGroupsMembershipsGet", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudidentityGroupsMembershipsGet_580013, base: "/",
    url: url_CloudidentityGroupsMembershipsGet_580014, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsPatch_580064 = ref object of OpenApiRestCall_579408
proc url_CloudidentityGroupsPatch_580066(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsPatch_580065(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a Group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Group in the format: `groups/{group_id}`, where group_id is the unique ID
  ## assigned to the Group.
  ## 
  ## Must be left blank while creating a Group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580067 = path.getOrDefault("name")
  valid_580067 = validateParameter(valid_580067, JString, required = true,
                                 default = nil)
  if valid_580067 != nil:
    section.add "name", valid_580067
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
  ##   updateMask: JString
  ##             : Editable fields: `display_name`, `description`
  section = newJObject()
  var valid_580068 = query.getOrDefault("upload_protocol")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "upload_protocol", valid_580068
  var valid_580069 = query.getOrDefault("fields")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "fields", valid_580069
  var valid_580070 = query.getOrDefault("quotaUser")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "quotaUser", valid_580070
  var valid_580071 = query.getOrDefault("alt")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = newJString("json"))
  if valid_580071 != nil:
    section.add "alt", valid_580071
  var valid_580072 = query.getOrDefault("oauth_token")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "oauth_token", valid_580072
  var valid_580073 = query.getOrDefault("callback")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "callback", valid_580073
  var valid_580074 = query.getOrDefault("access_token")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "access_token", valid_580074
  var valid_580075 = query.getOrDefault("uploadType")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "uploadType", valid_580075
  var valid_580076 = query.getOrDefault("key")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "key", valid_580076
  var valid_580077 = query.getOrDefault("$.xgafv")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = newJString("1"))
  if valid_580077 != nil:
    section.add "$.xgafv", valid_580077
  var valid_580078 = query.getOrDefault("prettyPrint")
  valid_580078 = validateParameter(valid_580078, JBool, required = false,
                                 default = newJBool(true))
  if valid_580078 != nil:
    section.add "prettyPrint", valid_580078
  var valid_580079 = query.getOrDefault("updateMask")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "updateMask", valid_580079
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

proc call*(call_580081: Call_CloudidentityGroupsPatch_580064; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Group.
  ## 
  let valid = call_580081.validator(path, query, header, formData, body)
  let scheme = call_580081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580081.url(scheme.get, call_580081.host, call_580081.base,
                         call_580081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580081, url, valid)

proc call*(call_580082: Call_CloudidentityGroupsPatch_580064; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
  ## cloudidentityGroupsPatch
  ## Updates a Group.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Group in the format: `groups/{group_id}`, where group_id is the unique ID
  ## assigned to the Group.
  ## 
  ## Must be left blank while creating a Group.
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
  ##   updateMask: string
  ##             : Editable fields: `display_name`, `description`
  var path_580083 = newJObject()
  var query_580084 = newJObject()
  var body_580085 = newJObject()
  add(query_580084, "upload_protocol", newJString(uploadProtocol))
  add(query_580084, "fields", newJString(fields))
  add(query_580084, "quotaUser", newJString(quotaUser))
  add(path_580083, "name", newJString(name))
  add(query_580084, "alt", newJString(alt))
  add(query_580084, "oauth_token", newJString(oauthToken))
  add(query_580084, "callback", newJString(callback))
  add(query_580084, "access_token", newJString(accessToken))
  add(query_580084, "uploadType", newJString(uploadType))
  add(query_580084, "key", newJString(key))
  add(query_580084, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580085 = body
  add(query_580084, "prettyPrint", newJBool(prettyPrint))
  add(query_580084, "updateMask", newJString(updateMask))
  result = call_580082.call(path_580083, query_580084, nil, nil, body_580085)

var cloudidentityGroupsPatch* = Call_CloudidentityGroupsPatch_580064(
    name: "cloudidentityGroupsPatch", meth: HttpMethod.HttpPatch,
    host: "cloudidentity.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudidentityGroupsPatch_580065, base: "/",
    url: url_CloudidentityGroupsPatch_580066, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsDelete_580045 = ref object of OpenApiRestCall_579408
proc url_CloudidentityGroupsMembershipsDelete_580047(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsMembershipsDelete_580046(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a Membership.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Membership to be deleted.
  ## 
  ## Format: `groups/{group_id}/memberships/{member_id}`, where `group_id` is
  ## the unique ID assigned to the Group to which Membership belongs to, and
  ## member_id is the unique ID assigned to the member.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580048 = path.getOrDefault("name")
  valid_580048 = validateParameter(valid_580048, JString, required = true,
                                 default = nil)
  if valid_580048 != nil:
    section.add "name", valid_580048
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
  var valid_580049 = query.getOrDefault("upload_protocol")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "upload_protocol", valid_580049
  var valid_580050 = query.getOrDefault("fields")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "fields", valid_580050
  var valid_580051 = query.getOrDefault("quotaUser")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "quotaUser", valid_580051
  var valid_580052 = query.getOrDefault("alt")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = newJString("json"))
  if valid_580052 != nil:
    section.add "alt", valid_580052
  var valid_580053 = query.getOrDefault("oauth_token")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "oauth_token", valid_580053
  var valid_580054 = query.getOrDefault("callback")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "callback", valid_580054
  var valid_580055 = query.getOrDefault("access_token")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "access_token", valid_580055
  var valid_580056 = query.getOrDefault("uploadType")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "uploadType", valid_580056
  var valid_580057 = query.getOrDefault("key")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "key", valid_580057
  var valid_580058 = query.getOrDefault("$.xgafv")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = newJString("1"))
  if valid_580058 != nil:
    section.add "$.xgafv", valid_580058
  var valid_580059 = query.getOrDefault("prettyPrint")
  valid_580059 = validateParameter(valid_580059, JBool, required = false,
                                 default = newJBool(true))
  if valid_580059 != nil:
    section.add "prettyPrint", valid_580059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580060: Call_CloudidentityGroupsMembershipsDelete_580045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a Membership.
  ## 
  let valid = call_580060.validator(path, query, header, formData, body)
  let scheme = call_580060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580060.url(scheme.get, call_580060.host, call_580060.base,
                         call_580060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580060, url, valid)

proc call*(call_580061: Call_CloudidentityGroupsMembershipsDelete_580045;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudidentityGroupsMembershipsDelete
  ## Deletes a Membership.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Membership to be deleted.
  ## 
  ## Format: `groups/{group_id}/memberships/{member_id}`, where `group_id` is
  ## the unique ID assigned to the Group to which Membership belongs to, and
  ## member_id is the unique ID assigned to the member.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580062 = newJObject()
  var query_580063 = newJObject()
  add(query_580063, "upload_protocol", newJString(uploadProtocol))
  add(query_580063, "fields", newJString(fields))
  add(query_580063, "quotaUser", newJString(quotaUser))
  add(path_580062, "name", newJString(name))
  add(query_580063, "alt", newJString(alt))
  add(query_580063, "oauth_token", newJString(oauthToken))
  add(query_580063, "callback", newJString(callback))
  add(query_580063, "access_token", newJString(accessToken))
  add(query_580063, "uploadType", newJString(uploadType))
  add(query_580063, "key", newJString(key))
  add(query_580063, "$.xgafv", newJString(Xgafv))
  add(query_580063, "prettyPrint", newJBool(prettyPrint))
  result = call_580061.call(path_580062, query_580063, nil, nil, nil)

var cloudidentityGroupsMembershipsDelete* = Call_CloudidentityGroupsMembershipsDelete_580045(
    name: "cloudidentityGroupsMembershipsDelete", meth: HttpMethod.HttpDelete,
    host: "cloudidentity.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudidentityGroupsMembershipsDelete_580046, base: "/",
    url: url_CloudidentityGroupsMembershipsDelete_580047, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsCreate_580108 = ref object of OpenApiRestCall_579408
proc url_CloudidentityGroupsMembershipsCreate_580110(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/memberships")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsMembershipsCreate_580109(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Membership.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Group to create Membership within. Format: `groups/{group_id}`, where
  ## `group_id` is the unique ID assigned to the Group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580111 = path.getOrDefault("parent")
  valid_580111 = validateParameter(valid_580111, JString, required = true,
                                 default = nil)
  if valid_580111 != nil:
    section.add "parent", valid_580111
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
  var valid_580112 = query.getOrDefault("upload_protocol")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "upload_protocol", valid_580112
  var valid_580113 = query.getOrDefault("fields")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "fields", valid_580113
  var valid_580114 = query.getOrDefault("quotaUser")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "quotaUser", valid_580114
  var valid_580115 = query.getOrDefault("alt")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = newJString("json"))
  if valid_580115 != nil:
    section.add "alt", valid_580115
  var valid_580116 = query.getOrDefault("oauth_token")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "oauth_token", valid_580116
  var valid_580117 = query.getOrDefault("callback")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "callback", valid_580117
  var valid_580118 = query.getOrDefault("access_token")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "access_token", valid_580118
  var valid_580119 = query.getOrDefault("uploadType")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "uploadType", valid_580119
  var valid_580120 = query.getOrDefault("key")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "key", valid_580120
  var valid_580121 = query.getOrDefault("$.xgafv")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = newJString("1"))
  if valid_580121 != nil:
    section.add "$.xgafv", valid_580121
  var valid_580122 = query.getOrDefault("prettyPrint")
  valid_580122 = validateParameter(valid_580122, JBool, required = false,
                                 default = newJBool(true))
  if valid_580122 != nil:
    section.add "prettyPrint", valid_580122
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

proc call*(call_580124: Call_CloudidentityGroupsMembershipsCreate_580108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Membership.
  ## 
  let valid = call_580124.validator(path, query, header, formData, body)
  let scheme = call_580124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580124.url(scheme.get, call_580124.host, call_580124.base,
                         call_580124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580124, url, valid)

proc call*(call_580125: Call_CloudidentityGroupsMembershipsCreate_580108;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudidentityGroupsMembershipsCreate
  ## Creates a Membership.
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
  ##   parent: string (required)
  ##         : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Group to create Membership within. Format: `groups/{group_id}`, where
  ## `group_id` is the unique ID assigned to the Group.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580126 = newJObject()
  var query_580127 = newJObject()
  var body_580128 = newJObject()
  add(query_580127, "upload_protocol", newJString(uploadProtocol))
  add(query_580127, "fields", newJString(fields))
  add(query_580127, "quotaUser", newJString(quotaUser))
  add(query_580127, "alt", newJString(alt))
  add(query_580127, "oauth_token", newJString(oauthToken))
  add(query_580127, "callback", newJString(callback))
  add(query_580127, "access_token", newJString(accessToken))
  add(query_580127, "uploadType", newJString(uploadType))
  add(path_580126, "parent", newJString(parent))
  add(query_580127, "key", newJString(key))
  add(query_580127, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580128 = body
  add(query_580127, "prettyPrint", newJBool(prettyPrint))
  result = call_580125.call(path_580126, query_580127, nil, nil, body_580128)

var cloudidentityGroupsMembershipsCreate* = Call_CloudidentityGroupsMembershipsCreate_580108(
    name: "cloudidentityGroupsMembershipsCreate", meth: HttpMethod.HttpPost,
    host: "cloudidentity.googleapis.com", route: "/v1/{parent}/memberships",
    validator: validate_CloudidentityGroupsMembershipsCreate_580109, base: "/",
    url: url_CloudidentityGroupsMembershipsCreate_580110, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsList_580086 = ref object of OpenApiRestCall_579408
proc url_CloudidentityGroupsMembershipsList_580088(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/memberships")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsMembershipsList_580087(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Memberships within a Group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Group to list Memberships within.
  ## 
  ## Format: `groups/{group_id}`, where `group_id` is the unique ID assigned to
  ## the Group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580089 = path.getOrDefault("parent")
  valid_580089 = validateParameter(valid_580089, JString, required = true,
                                 default = nil)
  if valid_580089 != nil:
    section.add "parent", valid_580089
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous list request, if any.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : Membership resource view to be returned. Defaults to View.BASIC.
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
  ##   pageSize: JInt
  ##           : The default page size is 200 (max 1000) for the BASIC view, and 50
  ## (max 500) for the FULL view.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580090 = query.getOrDefault("upload_protocol")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "upload_protocol", valid_580090
  var valid_580091 = query.getOrDefault("fields")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "fields", valid_580091
  var valid_580092 = query.getOrDefault("pageToken")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "pageToken", valid_580092
  var valid_580093 = query.getOrDefault("quotaUser")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "quotaUser", valid_580093
  var valid_580094 = query.getOrDefault("view")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_580094 != nil:
    section.add "view", valid_580094
  var valid_580095 = query.getOrDefault("alt")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = newJString("json"))
  if valid_580095 != nil:
    section.add "alt", valid_580095
  var valid_580096 = query.getOrDefault("oauth_token")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "oauth_token", valid_580096
  var valid_580097 = query.getOrDefault("callback")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "callback", valid_580097
  var valid_580098 = query.getOrDefault("access_token")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "access_token", valid_580098
  var valid_580099 = query.getOrDefault("uploadType")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "uploadType", valid_580099
  var valid_580100 = query.getOrDefault("key")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "key", valid_580100
  var valid_580101 = query.getOrDefault("$.xgafv")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = newJString("1"))
  if valid_580101 != nil:
    section.add "$.xgafv", valid_580101
  var valid_580102 = query.getOrDefault("pageSize")
  valid_580102 = validateParameter(valid_580102, JInt, required = false, default = nil)
  if valid_580102 != nil:
    section.add "pageSize", valid_580102
  var valid_580103 = query.getOrDefault("prettyPrint")
  valid_580103 = validateParameter(valid_580103, JBool, required = false,
                                 default = newJBool(true))
  if valid_580103 != nil:
    section.add "prettyPrint", valid_580103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580104: Call_CloudidentityGroupsMembershipsList_580086;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Memberships within a Group.
  ## 
  let valid = call_580104.validator(path, query, header, formData, body)
  let scheme = call_580104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580104.url(scheme.get, call_580104.host, call_580104.base,
                         call_580104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580104, url, valid)

proc call*(call_580105: Call_CloudidentityGroupsMembershipsList_580086;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = "";
          view: string = "VIEW_UNSPECIFIED"; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## cloudidentityGroupsMembershipsList
  ## List Memberships within a Group.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous list request, if any.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : Membership resource view to be returned. Defaults to View.BASIC.
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
  ##   parent: string (required)
  ##         : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Group to list Memberships within.
  ## 
  ## Format: `groups/{group_id}`, where `group_id` is the unique ID assigned to
  ## the Group.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The default page size is 200 (max 1000) for the BASIC view, and 50
  ## (max 500) for the FULL view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580106 = newJObject()
  var query_580107 = newJObject()
  add(query_580107, "upload_protocol", newJString(uploadProtocol))
  add(query_580107, "fields", newJString(fields))
  add(query_580107, "pageToken", newJString(pageToken))
  add(query_580107, "quotaUser", newJString(quotaUser))
  add(query_580107, "view", newJString(view))
  add(query_580107, "alt", newJString(alt))
  add(query_580107, "oauth_token", newJString(oauthToken))
  add(query_580107, "callback", newJString(callback))
  add(query_580107, "access_token", newJString(accessToken))
  add(query_580107, "uploadType", newJString(uploadType))
  add(path_580106, "parent", newJString(parent))
  add(query_580107, "key", newJString(key))
  add(query_580107, "$.xgafv", newJString(Xgafv))
  add(query_580107, "pageSize", newJInt(pageSize))
  add(query_580107, "prettyPrint", newJBool(prettyPrint))
  result = call_580105.call(path_580106, query_580107, nil, nil, nil)

var cloudidentityGroupsMembershipsList* = Call_CloudidentityGroupsMembershipsList_580086(
    name: "cloudidentityGroupsMembershipsList", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1/{parent}/memberships",
    validator: validate_CloudidentityGroupsMembershipsList_580087, base: "/",
    url: url_CloudidentityGroupsMembershipsList_580088, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsLookup_580129 = ref object of OpenApiRestCall_579408
proc url_CloudidentityGroupsMembershipsLookup_580131(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/memberships:lookup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsMembershipsLookup_580130(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Membership
  ## within a Group by member's EntityKey.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Group to lookup Membership within.
  ## 
  ## Format: `groups/{group_id}`, where `group_id` is the unique ID assigned to
  ## the Group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580132 = path.getOrDefault("parent")
  valid_580132 = validateParameter(valid_580132, JString, required = true,
                                 default = nil)
  if valid_580132 != nil:
    section.add "parent", valid_580132
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
  ##   memberKey.namespace: JString
  ##                      : Namespaces provide isolation for IDs, so an ID only needs to be unique
  ## within its namespace.
  ## 
  ## Namespaces are currently only created as part of IdentitySource creation
  ## from Admin Console. A namespace `"identitysources/{identity_source_id}"` is
  ## created corresponding to every Identity Source `identity_source_id`.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   memberKey.id: JString
  ##               : The ID of the entity within the given namespace. The ID must be unique
  ## within its namespace.
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
  var valid_580137 = query.getOrDefault("oauth_token")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "oauth_token", valid_580137
  var valid_580138 = query.getOrDefault("callback")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "callback", valid_580138
  var valid_580139 = query.getOrDefault("access_token")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "access_token", valid_580139
  var valid_580140 = query.getOrDefault("uploadType")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "uploadType", valid_580140
  var valid_580141 = query.getOrDefault("memberKey.namespace")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "memberKey.namespace", valid_580141
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
  var valid_580144 = query.getOrDefault("memberKey.id")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "memberKey.id", valid_580144
  var valid_580145 = query.getOrDefault("prettyPrint")
  valid_580145 = validateParameter(valid_580145, JBool, required = false,
                                 default = newJBool(true))
  if valid_580145 != nil:
    section.add "prettyPrint", valid_580145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580146: Call_CloudidentityGroupsMembershipsLookup_580129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Membership
  ## within a Group by member's EntityKey.
  ## 
  let valid = call_580146.validator(path, query, header, formData, body)
  let scheme = call_580146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580146.url(scheme.get, call_580146.host, call_580146.base,
                         call_580146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580146, url, valid)

proc call*(call_580147: Call_CloudidentityGroupsMembershipsLookup_580129;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          memberKeyNamespace: string = ""; key: string = ""; Xgafv: string = "1";
          memberKeyId: string = ""; prettyPrint: bool = true): Recallable =
  ## cloudidentityGroupsMembershipsLookup
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Membership
  ## within a Group by member's EntityKey.
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
  ##   parent: string (required)
  ##         : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Group to lookup Membership within.
  ## 
  ## Format: `groups/{group_id}`, where `group_id` is the unique ID assigned to
  ## the Group.
  ##   memberKeyNamespace: string
  ##                     : Namespaces provide isolation for IDs, so an ID only needs to be unique
  ## within its namespace.
  ## 
  ## Namespaces are currently only created as part of IdentitySource creation
  ## from Admin Console. A namespace `"identitysources/{identity_source_id}"` is
  ## created corresponding to every Identity Source `identity_source_id`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   memberKeyId: string
  ##              : The ID of the entity within the given namespace. The ID must be unique
  ## within its namespace.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580148 = newJObject()
  var query_580149 = newJObject()
  add(query_580149, "upload_protocol", newJString(uploadProtocol))
  add(query_580149, "fields", newJString(fields))
  add(query_580149, "quotaUser", newJString(quotaUser))
  add(query_580149, "alt", newJString(alt))
  add(query_580149, "oauth_token", newJString(oauthToken))
  add(query_580149, "callback", newJString(callback))
  add(query_580149, "access_token", newJString(accessToken))
  add(query_580149, "uploadType", newJString(uploadType))
  add(path_580148, "parent", newJString(parent))
  add(query_580149, "memberKey.namespace", newJString(memberKeyNamespace))
  add(query_580149, "key", newJString(key))
  add(query_580149, "$.xgafv", newJString(Xgafv))
  add(query_580149, "memberKey.id", newJString(memberKeyId))
  add(query_580149, "prettyPrint", newJBool(prettyPrint))
  result = call_580147.call(path_580148, query_580149, nil, nil, nil)

var cloudidentityGroupsMembershipsLookup* = Call_CloudidentityGroupsMembershipsLookup_580129(
    name: "cloudidentityGroupsMembershipsLookup", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com",
    route: "/v1/{parent}/memberships:lookup",
    validator: validate_CloudidentityGroupsMembershipsLookup_580130, base: "/",
    url: url_CloudidentityGroupsMembershipsLookup_580131, schemes: {Scheme.Https})
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
