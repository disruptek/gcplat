
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Identity
## version: v1beta1
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
  Call_CloudidentityGroupsCreate_579677 = ref object of OpenApiRestCall_579408
proc url_CloudidentityGroupsCreate_579679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsCreate_579678(path: JsonNode; query: JsonNode;
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
  var valid_579793 = query.getOrDefault("quotaUser")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "quotaUser", valid_579793
  var valid_579807 = query.getOrDefault("alt")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = newJString("json"))
  if valid_579807 != nil:
    section.add "alt", valid_579807
  var valid_579808 = query.getOrDefault("oauth_token")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "oauth_token", valid_579808
  var valid_579809 = query.getOrDefault("callback")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "callback", valid_579809
  var valid_579810 = query.getOrDefault("access_token")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "access_token", valid_579810
  var valid_579811 = query.getOrDefault("uploadType")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "uploadType", valid_579811
  var valid_579812 = query.getOrDefault("key")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "key", valid_579812
  var valid_579813 = query.getOrDefault("$.xgafv")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = newJString("1"))
  if valid_579813 != nil:
    section.add "$.xgafv", valid_579813
  var valid_579814 = query.getOrDefault("prettyPrint")
  valid_579814 = validateParameter(valid_579814, JBool, required = false,
                                 default = newJBool(true))
  if valid_579814 != nil:
    section.add "prettyPrint", valid_579814
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

proc call*(call_579838: Call_CloudidentityGroupsCreate_579677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Group.
  ## 
  let valid = call_579838.validator(path, query, header, formData, body)
  let scheme = call_579838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579838.url(scheme.get, call_579838.host, call_579838.base,
                         call_579838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579838, url, valid)

proc call*(call_579909: Call_CloudidentityGroupsCreate_579677;
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
  var query_579910 = newJObject()
  var body_579912 = newJObject()
  add(query_579910, "upload_protocol", newJString(uploadProtocol))
  add(query_579910, "fields", newJString(fields))
  add(query_579910, "quotaUser", newJString(quotaUser))
  add(query_579910, "alt", newJString(alt))
  add(query_579910, "oauth_token", newJString(oauthToken))
  add(query_579910, "callback", newJString(callback))
  add(query_579910, "access_token", newJString(accessToken))
  add(query_579910, "uploadType", newJString(uploadType))
  add(query_579910, "key", newJString(key))
  add(query_579910, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579912 = body
  add(query_579910, "prettyPrint", newJBool(prettyPrint))
  result = call_579909.call(nil, query_579910, nil, nil, body_579912)

var cloudidentityGroupsCreate* = Call_CloudidentityGroupsCreate_579677(
    name: "cloudidentityGroupsCreate", meth: HttpMethod.HttpPost,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/groups",
    validator: validate_CloudidentityGroupsCreate_579678, base: "/",
    url: url_CloudidentityGroupsCreate_579679, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsLookup_579951 = ref object of OpenApiRestCall_579408
proc url_CloudidentityGroupsLookup_579953(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsLookup_579952(path: JsonNode; query: JsonNode;
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
  ##                     : Namespaces provide isolation for ids, i.e an id only needs to be unique
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
  ##              : The id of the entity within the given namespace. The id must be unique
  ## within its namespace.
  section = newJObject()
  var valid_579954 = query.getOrDefault("upload_protocol")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "upload_protocol", valid_579954
  var valid_579955 = query.getOrDefault("fields")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "fields", valid_579955
  var valid_579956 = query.getOrDefault("quotaUser")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "quotaUser", valid_579956
  var valid_579957 = query.getOrDefault("alt")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = newJString("json"))
  if valid_579957 != nil:
    section.add "alt", valid_579957
  var valid_579958 = query.getOrDefault("oauth_token")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "oauth_token", valid_579958
  var valid_579959 = query.getOrDefault("callback")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "callback", valid_579959
  var valid_579960 = query.getOrDefault("access_token")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "access_token", valid_579960
  var valid_579961 = query.getOrDefault("uploadType")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "uploadType", valid_579961
  var valid_579962 = query.getOrDefault("groupKey.namespace")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "groupKey.namespace", valid_579962
  var valid_579963 = query.getOrDefault("key")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "key", valid_579963
  var valid_579964 = query.getOrDefault("$.xgafv")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = newJString("1"))
  if valid_579964 != nil:
    section.add "$.xgafv", valid_579964
  var valid_579965 = query.getOrDefault("prettyPrint")
  valid_579965 = validateParameter(valid_579965, JBool, required = false,
                                 default = newJBool(true))
  if valid_579965 != nil:
    section.add "prettyPrint", valid_579965
  var valid_579966 = query.getOrDefault("groupKey.id")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "groupKey.id", valid_579966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579967: Call_CloudidentityGroupsLookup_579951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Group by
  ## its EntityKey.
  ## 
  let valid = call_579967.validator(path, query, header, formData, body)
  let scheme = call_579967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579967.url(scheme.get, call_579967.host, call_579967.base,
                         call_579967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579967, url, valid)

proc call*(call_579968: Call_CloudidentityGroupsLookup_579951;
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
  ##                    : Namespaces provide isolation for ids, i.e an id only needs to be unique
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
  ##             : The id of the entity within the given namespace. The id must be unique
  ## within its namespace.
  var query_579969 = newJObject()
  add(query_579969, "upload_protocol", newJString(uploadProtocol))
  add(query_579969, "fields", newJString(fields))
  add(query_579969, "quotaUser", newJString(quotaUser))
  add(query_579969, "alt", newJString(alt))
  add(query_579969, "oauth_token", newJString(oauthToken))
  add(query_579969, "callback", newJString(callback))
  add(query_579969, "access_token", newJString(accessToken))
  add(query_579969, "uploadType", newJString(uploadType))
  add(query_579969, "groupKey.namespace", newJString(groupKeyNamespace))
  add(query_579969, "key", newJString(key))
  add(query_579969, "$.xgafv", newJString(Xgafv))
  add(query_579969, "prettyPrint", newJBool(prettyPrint))
  add(query_579969, "groupKey.id", newJString(groupKeyId))
  result = call_579968.call(nil, query_579969, nil, nil, nil)

var cloudidentityGroupsLookup* = Call_CloudidentityGroupsLookup_579951(
    name: "cloudidentityGroupsLookup", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/groups:lookup",
    validator: validate_CloudidentityGroupsLookup_579952, base: "/",
    url: url_CloudidentityGroupsLookup_579953, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsSearch_579970 = ref object of OpenApiRestCall_579408
proc url_CloudidentityGroupsSearch_579972(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsSearch_579971(path: JsonNode; query: JsonNode;
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
  ##       : Group resource view to be returned. Defaults to [GroupView.BASIC]().
  ##   alt: JString
  ##      : Data format for response.
  ##   query: JString
  ##        : Query string for performing search on groups.
  ## Users can search on namespace and label attributes of groups.
  ## EXACT match ('=') is supported on namespace, and CONTAINS match (':') is
  ## supported on labels. This is a `required` field.
  ## Multiple queries can be combined using `AND` operator. The operator is case
  ## sensitive.
  ## An example query would be:
  ## "namespace=<namespace_value> AND labels:<labels_value>".
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
  var valid_579973 = query.getOrDefault("upload_protocol")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "upload_protocol", valid_579973
  var valid_579974 = query.getOrDefault("fields")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "fields", valid_579974
  var valid_579975 = query.getOrDefault("pageToken")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "pageToken", valid_579975
  var valid_579976 = query.getOrDefault("quotaUser")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "quotaUser", valid_579976
  var valid_579977 = query.getOrDefault("view")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_579977 != nil:
    section.add "view", valid_579977
  var valid_579978 = query.getOrDefault("alt")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("json"))
  if valid_579978 != nil:
    section.add "alt", valid_579978
  var valid_579979 = query.getOrDefault("query")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "query", valid_579979
  var valid_579980 = query.getOrDefault("oauth_token")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "oauth_token", valid_579980
  var valid_579981 = query.getOrDefault("callback")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "callback", valid_579981
  var valid_579982 = query.getOrDefault("access_token")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "access_token", valid_579982
  var valid_579983 = query.getOrDefault("uploadType")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "uploadType", valid_579983
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
  var valid_579986 = query.getOrDefault("pageSize")
  valid_579986 = validateParameter(valid_579986, JInt, required = false, default = nil)
  if valid_579986 != nil:
    section.add "pageSize", valid_579986
  var valid_579987 = query.getOrDefault("prettyPrint")
  valid_579987 = validateParameter(valid_579987, JBool, required = false,
                                 default = newJBool(true))
  if valid_579987 != nil:
    section.add "prettyPrint", valid_579987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579988: Call_CloudidentityGroupsSearch_579970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for Groups.
  ## 
  let valid = call_579988.validator(path, query, header, formData, body)
  let scheme = call_579988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579988.url(scheme.get, call_579988.host, call_579988.base,
                         call_579988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579988, url, valid)

proc call*(call_579989: Call_CloudidentityGroupsSearch_579970;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; view: string = "BASIC"; alt: string = "json";
          query: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
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
  ##       : Group resource view to be returned. Defaults to [GroupView.BASIC]().
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : Query string for performing search on groups.
  ## Users can search on namespace and label attributes of groups.
  ## EXACT match ('=') is supported on namespace, and CONTAINS match (':') is
  ## supported on labels. This is a `required` field.
  ## Multiple queries can be combined using `AND` operator. The operator is case
  ## sensitive.
  ## An example query would be:
  ## "namespace=<namespace_value> AND labels:<labels_value>".
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
  var query_579990 = newJObject()
  add(query_579990, "upload_protocol", newJString(uploadProtocol))
  add(query_579990, "fields", newJString(fields))
  add(query_579990, "pageToken", newJString(pageToken))
  add(query_579990, "quotaUser", newJString(quotaUser))
  add(query_579990, "view", newJString(view))
  add(query_579990, "alt", newJString(alt))
  add(query_579990, "query", newJString(query))
  add(query_579990, "oauth_token", newJString(oauthToken))
  add(query_579990, "callback", newJString(callback))
  add(query_579990, "access_token", newJString(accessToken))
  add(query_579990, "uploadType", newJString(uploadType))
  add(query_579990, "key", newJString(key))
  add(query_579990, "$.xgafv", newJString(Xgafv))
  add(query_579990, "pageSize", newJInt(pageSize))
  add(query_579990, "prettyPrint", newJBool(prettyPrint))
  result = call_579989.call(nil, query_579990, nil, nil, nil)

var cloudidentityGroupsSearch* = Call_CloudidentityGroupsSearch_579970(
    name: "cloudidentityGroupsSearch", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/groups:search",
    validator: validate_CloudidentityGroupsSearch_579971, base: "/",
    url: url_CloudidentityGroupsSearch_579972, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsGet_579991 = ref object of OpenApiRestCall_579408
proc url_CloudidentityGroupsMembershipsGet_579993(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsMembershipsGet_579992(path: JsonNode;
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
  ## `member_id` is the unique id assigned to the member.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580008 = path.getOrDefault("name")
  valid_580008 = validateParameter(valid_580008, JString, required = true,
                                 default = nil)
  if valid_580008 != nil:
    section.add "name", valid_580008
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
  var valid_580009 = query.getOrDefault("upload_protocol")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "upload_protocol", valid_580009
  var valid_580010 = query.getOrDefault("fields")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "fields", valid_580010
  var valid_580011 = query.getOrDefault("quotaUser")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "quotaUser", valid_580011
  var valid_580012 = query.getOrDefault("alt")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = newJString("json"))
  if valid_580012 != nil:
    section.add "alt", valid_580012
  var valid_580013 = query.getOrDefault("oauth_token")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "oauth_token", valid_580013
  var valid_580014 = query.getOrDefault("callback")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "callback", valid_580014
  var valid_580015 = query.getOrDefault("access_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "access_token", valid_580015
  var valid_580016 = query.getOrDefault("uploadType")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "uploadType", valid_580016
  var valid_580017 = query.getOrDefault("key")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "key", valid_580017
  var valid_580018 = query.getOrDefault("$.xgafv")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("1"))
  if valid_580018 != nil:
    section.add "$.xgafv", valid_580018
  var valid_580019 = query.getOrDefault("prettyPrint")
  valid_580019 = validateParameter(valid_580019, JBool, required = false,
                                 default = newJBool(true))
  if valid_580019 != nil:
    section.add "prettyPrint", valid_580019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580020: Call_CloudidentityGroupsMembershipsGet_579991;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a Membership.
  ## 
  let valid = call_580020.validator(path, query, header, formData, body)
  let scheme = call_580020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580020.url(scheme.get, call_580020.host, call_580020.base,
                         call_580020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580020, url, valid)

proc call*(call_580021: Call_CloudidentityGroupsMembershipsGet_579991;
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
  ## `member_id` is the unique id assigned to the member.
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
  var path_580022 = newJObject()
  var query_580023 = newJObject()
  add(query_580023, "upload_protocol", newJString(uploadProtocol))
  add(query_580023, "fields", newJString(fields))
  add(query_580023, "quotaUser", newJString(quotaUser))
  add(path_580022, "name", newJString(name))
  add(query_580023, "alt", newJString(alt))
  add(query_580023, "oauth_token", newJString(oauthToken))
  add(query_580023, "callback", newJString(callback))
  add(query_580023, "access_token", newJString(accessToken))
  add(query_580023, "uploadType", newJString(uploadType))
  add(query_580023, "key", newJString(key))
  add(query_580023, "$.xgafv", newJString(Xgafv))
  add(query_580023, "prettyPrint", newJBool(prettyPrint))
  result = call_580021.call(path_580022, query_580023, nil, nil, nil)

var cloudidentityGroupsMembershipsGet* = Call_CloudidentityGroupsMembershipsGet_579991(
    name: "cloudidentityGroupsMembershipsGet", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudidentityGroupsMembershipsGet_579992, base: "/",
    url: url_CloudidentityGroupsMembershipsGet_579993, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsPatch_580043 = ref object of OpenApiRestCall_579408
proc url_CloudidentityGroupsPatch_580045(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsPatch_580044(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a Group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Group in the format: `groups/{group_id}`, where group_id is the unique id
  ## assigned to the Group.
  ## 
  ## Must be left blank while creating a Group
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580046 = path.getOrDefault("name")
  valid_580046 = validateParameter(valid_580046, JString, required = true,
                                 default = nil)
  if valid_580046 != nil:
    section.add "name", valid_580046
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
  var valid_580047 = query.getOrDefault("upload_protocol")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "upload_protocol", valid_580047
  var valid_580048 = query.getOrDefault("fields")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "fields", valid_580048
  var valid_580049 = query.getOrDefault("quotaUser")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "quotaUser", valid_580049
  var valid_580050 = query.getOrDefault("alt")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = newJString("json"))
  if valid_580050 != nil:
    section.add "alt", valid_580050
  var valid_580051 = query.getOrDefault("oauth_token")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "oauth_token", valid_580051
  var valid_580052 = query.getOrDefault("callback")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "callback", valid_580052
  var valid_580053 = query.getOrDefault("access_token")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "access_token", valid_580053
  var valid_580054 = query.getOrDefault("uploadType")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "uploadType", valid_580054
  var valid_580055 = query.getOrDefault("key")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "key", valid_580055
  var valid_580056 = query.getOrDefault("$.xgafv")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("1"))
  if valid_580056 != nil:
    section.add "$.xgafv", valid_580056
  var valid_580057 = query.getOrDefault("prettyPrint")
  valid_580057 = validateParameter(valid_580057, JBool, required = false,
                                 default = newJBool(true))
  if valid_580057 != nil:
    section.add "prettyPrint", valid_580057
  var valid_580058 = query.getOrDefault("updateMask")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "updateMask", valid_580058
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

proc call*(call_580060: Call_CloudidentityGroupsPatch_580043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Group.
  ## 
  let valid = call_580060.validator(path, query, header, formData, body)
  let scheme = call_580060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580060.url(scheme.get, call_580060.host, call_580060.base,
                         call_580060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580060, url, valid)

proc call*(call_580061: Call_CloudidentityGroupsPatch_580043; name: string;
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
  ## Group in the format: `groups/{group_id}`, where group_id is the unique id
  ## assigned to the Group.
  ## 
  ## Must be left blank while creating a Group
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
  var path_580062 = newJObject()
  var query_580063 = newJObject()
  var body_580064 = newJObject()
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
  if body != nil:
    body_580064 = body
  add(query_580063, "prettyPrint", newJBool(prettyPrint))
  add(query_580063, "updateMask", newJString(updateMask))
  result = call_580061.call(path_580062, query_580063, nil, nil, body_580064)

var cloudidentityGroupsPatch* = Call_CloudidentityGroupsPatch_580043(
    name: "cloudidentityGroupsPatch", meth: HttpMethod.HttpPatch,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudidentityGroupsPatch_580044, base: "/",
    url: url_CloudidentityGroupsPatch_580045, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsDelete_580024 = ref object of OpenApiRestCall_579408
proc url_CloudidentityGroupsMembershipsDelete_580026(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsMembershipsDelete_580025(path: JsonNode;
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
  ## the unique id assigned to the Group to which Membership belongs to, and
  ## member_id is the unique id assigned to the member.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580027 = path.getOrDefault("name")
  valid_580027 = validateParameter(valid_580027, JString, required = true,
                                 default = nil)
  if valid_580027 != nil:
    section.add "name", valid_580027
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
  var valid_580028 = query.getOrDefault("upload_protocol")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "upload_protocol", valid_580028
  var valid_580029 = query.getOrDefault("fields")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "fields", valid_580029
  var valid_580030 = query.getOrDefault("quotaUser")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "quotaUser", valid_580030
  var valid_580031 = query.getOrDefault("alt")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = newJString("json"))
  if valid_580031 != nil:
    section.add "alt", valid_580031
  var valid_580032 = query.getOrDefault("oauth_token")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "oauth_token", valid_580032
  var valid_580033 = query.getOrDefault("callback")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "callback", valid_580033
  var valid_580034 = query.getOrDefault("access_token")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "access_token", valid_580034
  var valid_580035 = query.getOrDefault("uploadType")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "uploadType", valid_580035
  var valid_580036 = query.getOrDefault("key")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "key", valid_580036
  var valid_580037 = query.getOrDefault("$.xgafv")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = newJString("1"))
  if valid_580037 != nil:
    section.add "$.xgafv", valid_580037
  var valid_580038 = query.getOrDefault("prettyPrint")
  valid_580038 = validateParameter(valid_580038, JBool, required = false,
                                 default = newJBool(true))
  if valid_580038 != nil:
    section.add "prettyPrint", valid_580038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580039: Call_CloudidentityGroupsMembershipsDelete_580024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a Membership.
  ## 
  let valid = call_580039.validator(path, query, header, formData, body)
  let scheme = call_580039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580039.url(scheme.get, call_580039.host, call_580039.base,
                         call_580039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580039, url, valid)

proc call*(call_580040: Call_CloudidentityGroupsMembershipsDelete_580024;
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
  ## the unique id assigned to the Group to which Membership belongs to, and
  ## member_id is the unique id assigned to the member.
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
  var path_580041 = newJObject()
  var query_580042 = newJObject()
  add(query_580042, "upload_protocol", newJString(uploadProtocol))
  add(query_580042, "fields", newJString(fields))
  add(query_580042, "quotaUser", newJString(quotaUser))
  add(path_580041, "name", newJString(name))
  add(query_580042, "alt", newJString(alt))
  add(query_580042, "oauth_token", newJString(oauthToken))
  add(query_580042, "callback", newJString(callback))
  add(query_580042, "access_token", newJString(accessToken))
  add(query_580042, "uploadType", newJString(uploadType))
  add(query_580042, "key", newJString(key))
  add(query_580042, "$.xgafv", newJString(Xgafv))
  add(query_580042, "prettyPrint", newJBool(prettyPrint))
  result = call_580040.call(path_580041, query_580042, nil, nil, nil)

var cloudidentityGroupsMembershipsDelete* = Call_CloudidentityGroupsMembershipsDelete_580024(
    name: "cloudidentityGroupsMembershipsDelete", meth: HttpMethod.HttpDelete,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudidentityGroupsMembershipsDelete_580025, base: "/",
    url: url_CloudidentityGroupsMembershipsDelete_580026, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsCreate_580087 = ref object of OpenApiRestCall_579408
proc url_CloudidentityGroupsMembershipsCreate_580089(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/memberships")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsMembershipsCreate_580088(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Membership.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : [Resource name](https://cloud.google.com/apis/design/resource_names) of the
  ## Group to create Membership within. Format: `groups/{group_id}`, where
  ## `group_id` is the unique id assigned to the Group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580090 = path.getOrDefault("parent")
  valid_580090 = validateParameter(valid_580090, JString, required = true,
                                 default = nil)
  if valid_580090 != nil:
    section.add "parent", valid_580090
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
  var valid_580091 = query.getOrDefault("upload_protocol")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "upload_protocol", valid_580091
  var valid_580092 = query.getOrDefault("fields")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "fields", valid_580092
  var valid_580093 = query.getOrDefault("quotaUser")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "quotaUser", valid_580093
  var valid_580094 = query.getOrDefault("alt")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = newJString("json"))
  if valid_580094 != nil:
    section.add "alt", valid_580094
  var valid_580095 = query.getOrDefault("oauth_token")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "oauth_token", valid_580095
  var valid_580096 = query.getOrDefault("callback")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "callback", valid_580096
  var valid_580097 = query.getOrDefault("access_token")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "access_token", valid_580097
  var valid_580098 = query.getOrDefault("uploadType")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "uploadType", valid_580098
  var valid_580099 = query.getOrDefault("key")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "key", valid_580099
  var valid_580100 = query.getOrDefault("$.xgafv")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = newJString("1"))
  if valid_580100 != nil:
    section.add "$.xgafv", valid_580100
  var valid_580101 = query.getOrDefault("prettyPrint")
  valid_580101 = validateParameter(valid_580101, JBool, required = false,
                                 default = newJBool(true))
  if valid_580101 != nil:
    section.add "prettyPrint", valid_580101
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

proc call*(call_580103: Call_CloudidentityGroupsMembershipsCreate_580087;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Membership.
  ## 
  let valid = call_580103.validator(path, query, header, formData, body)
  let scheme = call_580103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580103.url(scheme.get, call_580103.host, call_580103.base,
                         call_580103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580103, url, valid)

proc call*(call_580104: Call_CloudidentityGroupsMembershipsCreate_580087;
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
  ## `group_id` is the unique id assigned to the Group.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580105 = newJObject()
  var query_580106 = newJObject()
  var body_580107 = newJObject()
  add(query_580106, "upload_protocol", newJString(uploadProtocol))
  add(query_580106, "fields", newJString(fields))
  add(query_580106, "quotaUser", newJString(quotaUser))
  add(query_580106, "alt", newJString(alt))
  add(query_580106, "oauth_token", newJString(oauthToken))
  add(query_580106, "callback", newJString(callback))
  add(query_580106, "access_token", newJString(accessToken))
  add(query_580106, "uploadType", newJString(uploadType))
  add(path_580105, "parent", newJString(parent))
  add(query_580106, "key", newJString(key))
  add(query_580106, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580107 = body
  add(query_580106, "prettyPrint", newJBool(prettyPrint))
  result = call_580104.call(path_580105, query_580106, nil, nil, body_580107)

var cloudidentityGroupsMembershipsCreate* = Call_CloudidentityGroupsMembershipsCreate_580087(
    name: "cloudidentityGroupsMembershipsCreate", meth: HttpMethod.HttpPost,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/{parent}/memberships",
    validator: validate_CloudidentityGroupsMembershipsCreate_580088, base: "/",
    url: url_CloudidentityGroupsMembershipsCreate_580089, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsList_580065 = ref object of OpenApiRestCall_579408
proc url_CloudidentityGroupsMembershipsList_580067(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/memberships")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsMembershipsList_580066(path: JsonNode;
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
  ## Format: `groups/{group_id}`, where `group_id` is the unique id assigned to
  ## the Group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580068 = path.getOrDefault("parent")
  valid_580068 = validateParameter(valid_580068, JString, required = true,
                                 default = nil)
  if valid_580068 != nil:
    section.add "parent", valid_580068
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous list request, if any
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : Membership resource view to be returned. Defaults to MembershipView.BASIC.
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
  var valid_580069 = query.getOrDefault("upload_protocol")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "upload_protocol", valid_580069
  var valid_580070 = query.getOrDefault("fields")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "fields", valid_580070
  var valid_580071 = query.getOrDefault("pageToken")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "pageToken", valid_580071
  var valid_580072 = query.getOrDefault("quotaUser")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "quotaUser", valid_580072
  var valid_580073 = query.getOrDefault("view")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580073 != nil:
    section.add "view", valid_580073
  var valid_580074 = query.getOrDefault("alt")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = newJString("json"))
  if valid_580074 != nil:
    section.add "alt", valid_580074
  var valid_580075 = query.getOrDefault("oauth_token")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "oauth_token", valid_580075
  var valid_580076 = query.getOrDefault("callback")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "callback", valid_580076
  var valid_580077 = query.getOrDefault("access_token")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "access_token", valid_580077
  var valid_580078 = query.getOrDefault("uploadType")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "uploadType", valid_580078
  var valid_580079 = query.getOrDefault("key")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "key", valid_580079
  var valid_580080 = query.getOrDefault("$.xgafv")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = newJString("1"))
  if valid_580080 != nil:
    section.add "$.xgafv", valid_580080
  var valid_580081 = query.getOrDefault("pageSize")
  valid_580081 = validateParameter(valid_580081, JInt, required = false, default = nil)
  if valid_580081 != nil:
    section.add "pageSize", valid_580081
  var valid_580082 = query.getOrDefault("prettyPrint")
  valid_580082 = validateParameter(valid_580082, JBool, required = false,
                                 default = newJBool(true))
  if valid_580082 != nil:
    section.add "prettyPrint", valid_580082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580083: Call_CloudidentityGroupsMembershipsList_580065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Memberships within a Group.
  ## 
  let valid = call_580083.validator(path, query, header, formData, body)
  let scheme = call_580083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580083.url(scheme.get, call_580083.host, call_580083.base,
                         call_580083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580083, url, valid)

proc call*(call_580084: Call_CloudidentityGroupsMembershipsList_580065;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; view: string = "BASIC";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## cloudidentityGroupsMembershipsList
  ## List Memberships within a Group.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous list request, if any
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : Membership resource view to be returned. Defaults to MembershipView.BASIC.
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
  ## Format: `groups/{group_id}`, where `group_id` is the unique id assigned to
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
  var path_580085 = newJObject()
  var query_580086 = newJObject()
  add(query_580086, "upload_protocol", newJString(uploadProtocol))
  add(query_580086, "fields", newJString(fields))
  add(query_580086, "pageToken", newJString(pageToken))
  add(query_580086, "quotaUser", newJString(quotaUser))
  add(query_580086, "view", newJString(view))
  add(query_580086, "alt", newJString(alt))
  add(query_580086, "oauth_token", newJString(oauthToken))
  add(query_580086, "callback", newJString(callback))
  add(query_580086, "access_token", newJString(accessToken))
  add(query_580086, "uploadType", newJString(uploadType))
  add(path_580085, "parent", newJString(parent))
  add(query_580086, "key", newJString(key))
  add(query_580086, "$.xgafv", newJString(Xgafv))
  add(query_580086, "pageSize", newJInt(pageSize))
  add(query_580086, "prettyPrint", newJBool(prettyPrint))
  result = call_580084.call(path_580085, query_580086, nil, nil, nil)

var cloudidentityGroupsMembershipsList* = Call_CloudidentityGroupsMembershipsList_580065(
    name: "cloudidentityGroupsMembershipsList", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/{parent}/memberships",
    validator: validate_CloudidentityGroupsMembershipsList_580066, base: "/",
    url: url_CloudidentityGroupsMembershipsList_580067, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsLookup_580108 = ref object of OpenApiRestCall_579408
proc url_CloudidentityGroupsMembershipsLookup_580110(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/memberships:lookup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsMembershipsLookup_580109(path: JsonNode;
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
  ## Format: `groups/{group_id}`, where `group_id` is the unique id assigned to
  ## the Group.
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
  ##   memberKey.namespace: JString
  ##                      : Namespaces provide isolation for ids, i.e an id only needs to be unique
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
  ##               : The id of the entity within the given namespace. The id must be unique
  ## within its namespace.
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
  var valid_580120 = query.getOrDefault("memberKey.namespace")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "memberKey.namespace", valid_580120
  var valid_580121 = query.getOrDefault("key")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "key", valid_580121
  var valid_580122 = query.getOrDefault("$.xgafv")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = newJString("1"))
  if valid_580122 != nil:
    section.add "$.xgafv", valid_580122
  var valid_580123 = query.getOrDefault("memberKey.id")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "memberKey.id", valid_580123
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
  if body != nil:
    result.add "body", body

proc call*(call_580125: Call_CloudidentityGroupsMembershipsLookup_580108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Membership
  ## within a Group by member's EntityKey.
  ## 
  let valid = call_580125.validator(path, query, header, formData, body)
  let scheme = call_580125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580125.url(scheme.get, call_580125.host, call_580125.base,
                         call_580125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580125, url, valid)

proc call*(call_580126: Call_CloudidentityGroupsMembershipsLookup_580108;
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
  ## Format: `groups/{group_id}`, where `group_id` is the unique id assigned to
  ## the Group.
  ##   memberKeyNamespace: string
  ##                     : Namespaces provide isolation for ids, i.e an id only needs to be unique
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
  ##              : The id of the entity within the given namespace. The id must be unique
  ## within its namespace.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580127 = newJObject()
  var query_580128 = newJObject()
  add(query_580128, "upload_protocol", newJString(uploadProtocol))
  add(query_580128, "fields", newJString(fields))
  add(query_580128, "quotaUser", newJString(quotaUser))
  add(query_580128, "alt", newJString(alt))
  add(query_580128, "oauth_token", newJString(oauthToken))
  add(query_580128, "callback", newJString(callback))
  add(query_580128, "access_token", newJString(accessToken))
  add(query_580128, "uploadType", newJString(uploadType))
  add(path_580127, "parent", newJString(parent))
  add(query_580128, "memberKey.namespace", newJString(memberKeyNamespace))
  add(query_580128, "key", newJString(key))
  add(query_580128, "$.xgafv", newJString(Xgafv))
  add(query_580128, "memberKey.id", newJString(memberKeyId))
  add(query_580128, "prettyPrint", newJBool(prettyPrint))
  result = call_580126.call(path_580127, query_580128, nil, nil, nil)

var cloudidentityGroupsMembershipsLookup* = Call_CloudidentityGroupsMembershipsLookup_580108(
    name: "cloudidentityGroupsMembershipsLookup", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com",
    route: "/v1beta1/{parent}/memberships:lookup",
    validator: validate_CloudidentityGroupsMembershipsLookup_580109, base: "/",
    url: url_CloudidentityGroupsMembershipsLookup_580110, schemes: {Scheme.Https})
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
