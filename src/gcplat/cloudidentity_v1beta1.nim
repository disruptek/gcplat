
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudidentityGroupsCreate_597677 = ref object of OpenApiRestCall_597408
proc url_CloudidentityGroupsCreate_597679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsCreate_597678(path: JsonNode; query: JsonNode;
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
  var valid_597791 = query.getOrDefault("upload_protocol")
  valid_597791 = validateParameter(valid_597791, JString, required = false,
                                 default = nil)
  if valid_597791 != nil:
    section.add "upload_protocol", valid_597791
  var valid_597792 = query.getOrDefault("fields")
  valid_597792 = validateParameter(valid_597792, JString, required = false,
                                 default = nil)
  if valid_597792 != nil:
    section.add "fields", valid_597792
  var valid_597793 = query.getOrDefault("quotaUser")
  valid_597793 = validateParameter(valid_597793, JString, required = false,
                                 default = nil)
  if valid_597793 != nil:
    section.add "quotaUser", valid_597793
  var valid_597807 = query.getOrDefault("alt")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = newJString("json"))
  if valid_597807 != nil:
    section.add "alt", valid_597807
  var valid_597808 = query.getOrDefault("oauth_token")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "oauth_token", valid_597808
  var valid_597809 = query.getOrDefault("callback")
  valid_597809 = validateParameter(valid_597809, JString, required = false,
                                 default = nil)
  if valid_597809 != nil:
    section.add "callback", valid_597809
  var valid_597810 = query.getOrDefault("access_token")
  valid_597810 = validateParameter(valid_597810, JString, required = false,
                                 default = nil)
  if valid_597810 != nil:
    section.add "access_token", valid_597810
  var valid_597811 = query.getOrDefault("uploadType")
  valid_597811 = validateParameter(valid_597811, JString, required = false,
                                 default = nil)
  if valid_597811 != nil:
    section.add "uploadType", valid_597811
  var valid_597812 = query.getOrDefault("key")
  valid_597812 = validateParameter(valid_597812, JString, required = false,
                                 default = nil)
  if valid_597812 != nil:
    section.add "key", valid_597812
  var valid_597813 = query.getOrDefault("$.xgafv")
  valid_597813 = validateParameter(valid_597813, JString, required = false,
                                 default = newJString("1"))
  if valid_597813 != nil:
    section.add "$.xgafv", valid_597813
  var valid_597814 = query.getOrDefault("prettyPrint")
  valid_597814 = validateParameter(valid_597814, JBool, required = false,
                                 default = newJBool(true))
  if valid_597814 != nil:
    section.add "prettyPrint", valid_597814
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

proc call*(call_597838: Call_CloudidentityGroupsCreate_597677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Group.
  ## 
  let valid = call_597838.validator(path, query, header, formData, body)
  let scheme = call_597838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597838.url(scheme.get, call_597838.host, call_597838.base,
                         call_597838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597838, url, valid)

proc call*(call_597909: Call_CloudidentityGroupsCreate_597677;
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
  var query_597910 = newJObject()
  var body_597912 = newJObject()
  add(query_597910, "upload_protocol", newJString(uploadProtocol))
  add(query_597910, "fields", newJString(fields))
  add(query_597910, "quotaUser", newJString(quotaUser))
  add(query_597910, "alt", newJString(alt))
  add(query_597910, "oauth_token", newJString(oauthToken))
  add(query_597910, "callback", newJString(callback))
  add(query_597910, "access_token", newJString(accessToken))
  add(query_597910, "uploadType", newJString(uploadType))
  add(query_597910, "key", newJString(key))
  add(query_597910, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597912 = body
  add(query_597910, "prettyPrint", newJBool(prettyPrint))
  result = call_597909.call(nil, query_597910, nil, nil, body_597912)

var cloudidentityGroupsCreate* = Call_CloudidentityGroupsCreate_597677(
    name: "cloudidentityGroupsCreate", meth: HttpMethod.HttpPost,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/groups",
    validator: validate_CloudidentityGroupsCreate_597678, base: "/",
    url: url_CloudidentityGroupsCreate_597679, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsLookup_597951 = ref object of OpenApiRestCall_597408
proc url_CloudidentityGroupsLookup_597953(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsLookup_597952(path: JsonNode; query: JsonNode;
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
  var valid_597954 = query.getOrDefault("upload_protocol")
  valid_597954 = validateParameter(valid_597954, JString, required = false,
                                 default = nil)
  if valid_597954 != nil:
    section.add "upload_protocol", valid_597954
  var valid_597955 = query.getOrDefault("fields")
  valid_597955 = validateParameter(valid_597955, JString, required = false,
                                 default = nil)
  if valid_597955 != nil:
    section.add "fields", valid_597955
  var valid_597956 = query.getOrDefault("quotaUser")
  valid_597956 = validateParameter(valid_597956, JString, required = false,
                                 default = nil)
  if valid_597956 != nil:
    section.add "quotaUser", valid_597956
  var valid_597957 = query.getOrDefault("alt")
  valid_597957 = validateParameter(valid_597957, JString, required = false,
                                 default = newJString("json"))
  if valid_597957 != nil:
    section.add "alt", valid_597957
  var valid_597958 = query.getOrDefault("oauth_token")
  valid_597958 = validateParameter(valid_597958, JString, required = false,
                                 default = nil)
  if valid_597958 != nil:
    section.add "oauth_token", valid_597958
  var valid_597959 = query.getOrDefault("callback")
  valid_597959 = validateParameter(valid_597959, JString, required = false,
                                 default = nil)
  if valid_597959 != nil:
    section.add "callback", valid_597959
  var valid_597960 = query.getOrDefault("access_token")
  valid_597960 = validateParameter(valid_597960, JString, required = false,
                                 default = nil)
  if valid_597960 != nil:
    section.add "access_token", valid_597960
  var valid_597961 = query.getOrDefault("uploadType")
  valid_597961 = validateParameter(valid_597961, JString, required = false,
                                 default = nil)
  if valid_597961 != nil:
    section.add "uploadType", valid_597961
  var valid_597962 = query.getOrDefault("groupKey.namespace")
  valid_597962 = validateParameter(valid_597962, JString, required = false,
                                 default = nil)
  if valid_597962 != nil:
    section.add "groupKey.namespace", valid_597962
  var valid_597963 = query.getOrDefault("key")
  valid_597963 = validateParameter(valid_597963, JString, required = false,
                                 default = nil)
  if valid_597963 != nil:
    section.add "key", valid_597963
  var valid_597964 = query.getOrDefault("$.xgafv")
  valid_597964 = validateParameter(valid_597964, JString, required = false,
                                 default = newJString("1"))
  if valid_597964 != nil:
    section.add "$.xgafv", valid_597964
  var valid_597965 = query.getOrDefault("prettyPrint")
  valid_597965 = validateParameter(valid_597965, JBool, required = false,
                                 default = newJBool(true))
  if valid_597965 != nil:
    section.add "prettyPrint", valid_597965
  var valid_597966 = query.getOrDefault("groupKey.id")
  valid_597966 = validateParameter(valid_597966, JString, required = false,
                                 default = nil)
  if valid_597966 != nil:
    section.add "groupKey.id", valid_597966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597967: Call_CloudidentityGroupsLookup_597951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Group by
  ## its EntityKey.
  ## 
  let valid = call_597967.validator(path, query, header, formData, body)
  let scheme = call_597967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597967.url(scheme.get, call_597967.host, call_597967.base,
                         call_597967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597967, url, valid)

proc call*(call_597968: Call_CloudidentityGroupsLookup_597951;
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
  var query_597969 = newJObject()
  add(query_597969, "upload_protocol", newJString(uploadProtocol))
  add(query_597969, "fields", newJString(fields))
  add(query_597969, "quotaUser", newJString(quotaUser))
  add(query_597969, "alt", newJString(alt))
  add(query_597969, "oauth_token", newJString(oauthToken))
  add(query_597969, "callback", newJString(callback))
  add(query_597969, "access_token", newJString(accessToken))
  add(query_597969, "uploadType", newJString(uploadType))
  add(query_597969, "groupKey.namespace", newJString(groupKeyNamespace))
  add(query_597969, "key", newJString(key))
  add(query_597969, "$.xgafv", newJString(Xgafv))
  add(query_597969, "prettyPrint", newJBool(prettyPrint))
  add(query_597969, "groupKey.id", newJString(groupKeyId))
  result = call_597968.call(nil, query_597969, nil, nil, nil)

var cloudidentityGroupsLookup* = Call_CloudidentityGroupsLookup_597951(
    name: "cloudidentityGroupsLookup", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/groups:lookup",
    validator: validate_CloudidentityGroupsLookup_597952, base: "/",
    url: url_CloudidentityGroupsLookup_597953, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsSearch_597970 = ref object of OpenApiRestCall_597408
proc url_CloudidentityGroupsSearch_597972(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsSearch_597971(path: JsonNode; query: JsonNode;
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
  var valid_597973 = query.getOrDefault("upload_protocol")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "upload_protocol", valid_597973
  var valid_597974 = query.getOrDefault("fields")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "fields", valid_597974
  var valid_597975 = query.getOrDefault("pageToken")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "pageToken", valid_597975
  var valid_597976 = query.getOrDefault("quotaUser")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "quotaUser", valid_597976
  var valid_597977 = query.getOrDefault("view")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_597977 != nil:
    section.add "view", valid_597977
  var valid_597978 = query.getOrDefault("alt")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = newJString("json"))
  if valid_597978 != nil:
    section.add "alt", valid_597978
  var valid_597979 = query.getOrDefault("query")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = nil)
  if valid_597979 != nil:
    section.add "query", valid_597979
  var valid_597980 = query.getOrDefault("oauth_token")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "oauth_token", valid_597980
  var valid_597981 = query.getOrDefault("callback")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "callback", valid_597981
  var valid_597982 = query.getOrDefault("access_token")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = nil)
  if valid_597982 != nil:
    section.add "access_token", valid_597982
  var valid_597983 = query.getOrDefault("uploadType")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = nil)
  if valid_597983 != nil:
    section.add "uploadType", valid_597983
  var valid_597984 = query.getOrDefault("key")
  valid_597984 = validateParameter(valid_597984, JString, required = false,
                                 default = nil)
  if valid_597984 != nil:
    section.add "key", valid_597984
  var valid_597985 = query.getOrDefault("$.xgafv")
  valid_597985 = validateParameter(valid_597985, JString, required = false,
                                 default = newJString("1"))
  if valid_597985 != nil:
    section.add "$.xgafv", valid_597985
  var valid_597986 = query.getOrDefault("pageSize")
  valid_597986 = validateParameter(valid_597986, JInt, required = false, default = nil)
  if valid_597986 != nil:
    section.add "pageSize", valid_597986
  var valid_597987 = query.getOrDefault("prettyPrint")
  valid_597987 = validateParameter(valid_597987, JBool, required = false,
                                 default = newJBool(true))
  if valid_597987 != nil:
    section.add "prettyPrint", valid_597987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597988: Call_CloudidentityGroupsSearch_597970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for Groups.
  ## 
  let valid = call_597988.validator(path, query, header, formData, body)
  let scheme = call_597988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597988.url(scheme.get, call_597988.host, call_597988.base,
                         call_597988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597988, url, valid)

proc call*(call_597989: Call_CloudidentityGroupsSearch_597970;
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
  var query_597990 = newJObject()
  add(query_597990, "upload_protocol", newJString(uploadProtocol))
  add(query_597990, "fields", newJString(fields))
  add(query_597990, "pageToken", newJString(pageToken))
  add(query_597990, "quotaUser", newJString(quotaUser))
  add(query_597990, "view", newJString(view))
  add(query_597990, "alt", newJString(alt))
  add(query_597990, "query", newJString(query))
  add(query_597990, "oauth_token", newJString(oauthToken))
  add(query_597990, "callback", newJString(callback))
  add(query_597990, "access_token", newJString(accessToken))
  add(query_597990, "uploadType", newJString(uploadType))
  add(query_597990, "key", newJString(key))
  add(query_597990, "$.xgafv", newJString(Xgafv))
  add(query_597990, "pageSize", newJInt(pageSize))
  add(query_597990, "prettyPrint", newJBool(prettyPrint))
  result = call_597989.call(nil, query_597990, nil, nil, nil)

var cloudidentityGroupsSearch* = Call_CloudidentityGroupsSearch_597970(
    name: "cloudidentityGroupsSearch", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/groups:search",
    validator: validate_CloudidentityGroupsSearch_597971, base: "/",
    url: url_CloudidentityGroupsSearch_597972, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsGet_597991 = ref object of OpenApiRestCall_597408
proc url_CloudidentityGroupsMembershipsGet_597993(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsMembershipsGet_597992(path: JsonNode;
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
  var valid_598008 = path.getOrDefault("name")
  valid_598008 = validateParameter(valid_598008, JString, required = true,
                                 default = nil)
  if valid_598008 != nil:
    section.add "name", valid_598008
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
  var valid_598009 = query.getOrDefault("upload_protocol")
  valid_598009 = validateParameter(valid_598009, JString, required = false,
                                 default = nil)
  if valid_598009 != nil:
    section.add "upload_protocol", valid_598009
  var valid_598010 = query.getOrDefault("fields")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = nil)
  if valid_598010 != nil:
    section.add "fields", valid_598010
  var valid_598011 = query.getOrDefault("quotaUser")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "quotaUser", valid_598011
  var valid_598012 = query.getOrDefault("alt")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = newJString("json"))
  if valid_598012 != nil:
    section.add "alt", valid_598012
  var valid_598013 = query.getOrDefault("oauth_token")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "oauth_token", valid_598013
  var valid_598014 = query.getOrDefault("callback")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "callback", valid_598014
  var valid_598015 = query.getOrDefault("access_token")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "access_token", valid_598015
  var valid_598016 = query.getOrDefault("uploadType")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "uploadType", valid_598016
  var valid_598017 = query.getOrDefault("key")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "key", valid_598017
  var valid_598018 = query.getOrDefault("$.xgafv")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = newJString("1"))
  if valid_598018 != nil:
    section.add "$.xgafv", valid_598018
  var valid_598019 = query.getOrDefault("prettyPrint")
  valid_598019 = validateParameter(valid_598019, JBool, required = false,
                                 default = newJBool(true))
  if valid_598019 != nil:
    section.add "prettyPrint", valid_598019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598020: Call_CloudidentityGroupsMembershipsGet_597991;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a Membership.
  ## 
  let valid = call_598020.validator(path, query, header, formData, body)
  let scheme = call_598020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598020.url(scheme.get, call_598020.host, call_598020.base,
                         call_598020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598020, url, valid)

proc call*(call_598021: Call_CloudidentityGroupsMembershipsGet_597991;
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
  var path_598022 = newJObject()
  var query_598023 = newJObject()
  add(query_598023, "upload_protocol", newJString(uploadProtocol))
  add(query_598023, "fields", newJString(fields))
  add(query_598023, "quotaUser", newJString(quotaUser))
  add(path_598022, "name", newJString(name))
  add(query_598023, "alt", newJString(alt))
  add(query_598023, "oauth_token", newJString(oauthToken))
  add(query_598023, "callback", newJString(callback))
  add(query_598023, "access_token", newJString(accessToken))
  add(query_598023, "uploadType", newJString(uploadType))
  add(query_598023, "key", newJString(key))
  add(query_598023, "$.xgafv", newJString(Xgafv))
  add(query_598023, "prettyPrint", newJBool(prettyPrint))
  result = call_598021.call(path_598022, query_598023, nil, nil, nil)

var cloudidentityGroupsMembershipsGet* = Call_CloudidentityGroupsMembershipsGet_597991(
    name: "cloudidentityGroupsMembershipsGet", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudidentityGroupsMembershipsGet_597992, base: "/",
    url: url_CloudidentityGroupsMembershipsGet_597993, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsPatch_598043 = ref object of OpenApiRestCall_597408
proc url_CloudidentityGroupsPatch_598045(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsPatch_598044(path: JsonNode; query: JsonNode;
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
  var valid_598046 = path.getOrDefault("name")
  valid_598046 = validateParameter(valid_598046, JString, required = true,
                                 default = nil)
  if valid_598046 != nil:
    section.add "name", valid_598046
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
  var valid_598047 = query.getOrDefault("upload_protocol")
  valid_598047 = validateParameter(valid_598047, JString, required = false,
                                 default = nil)
  if valid_598047 != nil:
    section.add "upload_protocol", valid_598047
  var valid_598048 = query.getOrDefault("fields")
  valid_598048 = validateParameter(valid_598048, JString, required = false,
                                 default = nil)
  if valid_598048 != nil:
    section.add "fields", valid_598048
  var valid_598049 = query.getOrDefault("quotaUser")
  valid_598049 = validateParameter(valid_598049, JString, required = false,
                                 default = nil)
  if valid_598049 != nil:
    section.add "quotaUser", valid_598049
  var valid_598050 = query.getOrDefault("alt")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = newJString("json"))
  if valid_598050 != nil:
    section.add "alt", valid_598050
  var valid_598051 = query.getOrDefault("oauth_token")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = nil)
  if valid_598051 != nil:
    section.add "oauth_token", valid_598051
  var valid_598052 = query.getOrDefault("callback")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "callback", valid_598052
  var valid_598053 = query.getOrDefault("access_token")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "access_token", valid_598053
  var valid_598054 = query.getOrDefault("uploadType")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "uploadType", valid_598054
  var valid_598055 = query.getOrDefault("key")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "key", valid_598055
  var valid_598056 = query.getOrDefault("$.xgafv")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = newJString("1"))
  if valid_598056 != nil:
    section.add "$.xgafv", valid_598056
  var valid_598057 = query.getOrDefault("prettyPrint")
  valid_598057 = validateParameter(valid_598057, JBool, required = false,
                                 default = newJBool(true))
  if valid_598057 != nil:
    section.add "prettyPrint", valid_598057
  var valid_598058 = query.getOrDefault("updateMask")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "updateMask", valid_598058
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

proc call*(call_598060: Call_CloudidentityGroupsPatch_598043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Group.
  ## 
  let valid = call_598060.validator(path, query, header, formData, body)
  let scheme = call_598060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598060.url(scheme.get, call_598060.host, call_598060.base,
                         call_598060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598060, url, valid)

proc call*(call_598061: Call_CloudidentityGroupsPatch_598043; name: string;
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
  var path_598062 = newJObject()
  var query_598063 = newJObject()
  var body_598064 = newJObject()
  add(query_598063, "upload_protocol", newJString(uploadProtocol))
  add(query_598063, "fields", newJString(fields))
  add(query_598063, "quotaUser", newJString(quotaUser))
  add(path_598062, "name", newJString(name))
  add(query_598063, "alt", newJString(alt))
  add(query_598063, "oauth_token", newJString(oauthToken))
  add(query_598063, "callback", newJString(callback))
  add(query_598063, "access_token", newJString(accessToken))
  add(query_598063, "uploadType", newJString(uploadType))
  add(query_598063, "key", newJString(key))
  add(query_598063, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598064 = body
  add(query_598063, "prettyPrint", newJBool(prettyPrint))
  add(query_598063, "updateMask", newJString(updateMask))
  result = call_598061.call(path_598062, query_598063, nil, nil, body_598064)

var cloudidentityGroupsPatch* = Call_CloudidentityGroupsPatch_598043(
    name: "cloudidentityGroupsPatch", meth: HttpMethod.HttpPatch,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudidentityGroupsPatch_598044, base: "/",
    url: url_CloudidentityGroupsPatch_598045, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsDelete_598024 = ref object of OpenApiRestCall_597408
proc url_CloudidentityGroupsMembershipsDelete_598026(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsMembershipsDelete_598025(path: JsonNode;
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
  var valid_598027 = path.getOrDefault("name")
  valid_598027 = validateParameter(valid_598027, JString, required = true,
                                 default = nil)
  if valid_598027 != nil:
    section.add "name", valid_598027
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
  var valid_598028 = query.getOrDefault("upload_protocol")
  valid_598028 = validateParameter(valid_598028, JString, required = false,
                                 default = nil)
  if valid_598028 != nil:
    section.add "upload_protocol", valid_598028
  var valid_598029 = query.getOrDefault("fields")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "fields", valid_598029
  var valid_598030 = query.getOrDefault("quotaUser")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "quotaUser", valid_598030
  var valid_598031 = query.getOrDefault("alt")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = newJString("json"))
  if valid_598031 != nil:
    section.add "alt", valid_598031
  var valid_598032 = query.getOrDefault("oauth_token")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "oauth_token", valid_598032
  var valid_598033 = query.getOrDefault("callback")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "callback", valid_598033
  var valid_598034 = query.getOrDefault("access_token")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "access_token", valid_598034
  var valid_598035 = query.getOrDefault("uploadType")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "uploadType", valid_598035
  var valid_598036 = query.getOrDefault("key")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "key", valid_598036
  var valid_598037 = query.getOrDefault("$.xgafv")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = newJString("1"))
  if valid_598037 != nil:
    section.add "$.xgafv", valid_598037
  var valid_598038 = query.getOrDefault("prettyPrint")
  valid_598038 = validateParameter(valid_598038, JBool, required = false,
                                 default = newJBool(true))
  if valid_598038 != nil:
    section.add "prettyPrint", valid_598038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598039: Call_CloudidentityGroupsMembershipsDelete_598024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a Membership.
  ## 
  let valid = call_598039.validator(path, query, header, formData, body)
  let scheme = call_598039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598039.url(scheme.get, call_598039.host, call_598039.base,
                         call_598039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598039, url, valid)

proc call*(call_598040: Call_CloudidentityGroupsMembershipsDelete_598024;
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
  var path_598041 = newJObject()
  var query_598042 = newJObject()
  add(query_598042, "upload_protocol", newJString(uploadProtocol))
  add(query_598042, "fields", newJString(fields))
  add(query_598042, "quotaUser", newJString(quotaUser))
  add(path_598041, "name", newJString(name))
  add(query_598042, "alt", newJString(alt))
  add(query_598042, "oauth_token", newJString(oauthToken))
  add(query_598042, "callback", newJString(callback))
  add(query_598042, "access_token", newJString(accessToken))
  add(query_598042, "uploadType", newJString(uploadType))
  add(query_598042, "key", newJString(key))
  add(query_598042, "$.xgafv", newJString(Xgafv))
  add(query_598042, "prettyPrint", newJBool(prettyPrint))
  result = call_598040.call(path_598041, query_598042, nil, nil, nil)

var cloudidentityGroupsMembershipsDelete* = Call_CloudidentityGroupsMembershipsDelete_598024(
    name: "cloudidentityGroupsMembershipsDelete", meth: HttpMethod.HttpDelete,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudidentityGroupsMembershipsDelete_598025, base: "/",
    url: url_CloudidentityGroupsMembershipsDelete_598026, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsCreate_598087 = ref object of OpenApiRestCall_597408
proc url_CloudidentityGroupsMembershipsCreate_598089(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudidentityGroupsMembershipsCreate_598088(path: JsonNode;
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
  var valid_598090 = path.getOrDefault("parent")
  valid_598090 = validateParameter(valid_598090, JString, required = true,
                                 default = nil)
  if valid_598090 != nil:
    section.add "parent", valid_598090
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
  var valid_598091 = query.getOrDefault("upload_protocol")
  valid_598091 = validateParameter(valid_598091, JString, required = false,
                                 default = nil)
  if valid_598091 != nil:
    section.add "upload_protocol", valid_598091
  var valid_598092 = query.getOrDefault("fields")
  valid_598092 = validateParameter(valid_598092, JString, required = false,
                                 default = nil)
  if valid_598092 != nil:
    section.add "fields", valid_598092
  var valid_598093 = query.getOrDefault("quotaUser")
  valid_598093 = validateParameter(valid_598093, JString, required = false,
                                 default = nil)
  if valid_598093 != nil:
    section.add "quotaUser", valid_598093
  var valid_598094 = query.getOrDefault("alt")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = newJString("json"))
  if valid_598094 != nil:
    section.add "alt", valid_598094
  var valid_598095 = query.getOrDefault("oauth_token")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "oauth_token", valid_598095
  var valid_598096 = query.getOrDefault("callback")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "callback", valid_598096
  var valid_598097 = query.getOrDefault("access_token")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "access_token", valid_598097
  var valid_598098 = query.getOrDefault("uploadType")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = nil)
  if valid_598098 != nil:
    section.add "uploadType", valid_598098
  var valid_598099 = query.getOrDefault("key")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = nil)
  if valid_598099 != nil:
    section.add "key", valid_598099
  var valid_598100 = query.getOrDefault("$.xgafv")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = newJString("1"))
  if valid_598100 != nil:
    section.add "$.xgafv", valid_598100
  var valid_598101 = query.getOrDefault("prettyPrint")
  valid_598101 = validateParameter(valid_598101, JBool, required = false,
                                 default = newJBool(true))
  if valid_598101 != nil:
    section.add "prettyPrint", valid_598101
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

proc call*(call_598103: Call_CloudidentityGroupsMembershipsCreate_598087;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Membership.
  ## 
  let valid = call_598103.validator(path, query, header, formData, body)
  let scheme = call_598103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598103.url(scheme.get, call_598103.host, call_598103.base,
                         call_598103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598103, url, valid)

proc call*(call_598104: Call_CloudidentityGroupsMembershipsCreate_598087;
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
  var path_598105 = newJObject()
  var query_598106 = newJObject()
  var body_598107 = newJObject()
  add(query_598106, "upload_protocol", newJString(uploadProtocol))
  add(query_598106, "fields", newJString(fields))
  add(query_598106, "quotaUser", newJString(quotaUser))
  add(query_598106, "alt", newJString(alt))
  add(query_598106, "oauth_token", newJString(oauthToken))
  add(query_598106, "callback", newJString(callback))
  add(query_598106, "access_token", newJString(accessToken))
  add(query_598106, "uploadType", newJString(uploadType))
  add(path_598105, "parent", newJString(parent))
  add(query_598106, "key", newJString(key))
  add(query_598106, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598107 = body
  add(query_598106, "prettyPrint", newJBool(prettyPrint))
  result = call_598104.call(path_598105, query_598106, nil, nil, body_598107)

var cloudidentityGroupsMembershipsCreate* = Call_CloudidentityGroupsMembershipsCreate_598087(
    name: "cloudidentityGroupsMembershipsCreate", meth: HttpMethod.HttpPost,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/{parent}/memberships",
    validator: validate_CloudidentityGroupsMembershipsCreate_598088, base: "/",
    url: url_CloudidentityGroupsMembershipsCreate_598089, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsList_598065 = ref object of OpenApiRestCall_597408
proc url_CloudidentityGroupsMembershipsList_598067(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudidentityGroupsMembershipsList_598066(path: JsonNode;
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
  var valid_598068 = path.getOrDefault("parent")
  valid_598068 = validateParameter(valid_598068, JString, required = true,
                                 default = nil)
  if valid_598068 != nil:
    section.add "parent", valid_598068
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
  var valid_598069 = query.getOrDefault("upload_protocol")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = nil)
  if valid_598069 != nil:
    section.add "upload_protocol", valid_598069
  var valid_598070 = query.getOrDefault("fields")
  valid_598070 = validateParameter(valid_598070, JString, required = false,
                                 default = nil)
  if valid_598070 != nil:
    section.add "fields", valid_598070
  var valid_598071 = query.getOrDefault("pageToken")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "pageToken", valid_598071
  var valid_598072 = query.getOrDefault("quotaUser")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "quotaUser", valid_598072
  var valid_598073 = query.getOrDefault("view")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_598073 != nil:
    section.add "view", valid_598073
  var valid_598074 = query.getOrDefault("alt")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = newJString("json"))
  if valid_598074 != nil:
    section.add "alt", valid_598074
  var valid_598075 = query.getOrDefault("oauth_token")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "oauth_token", valid_598075
  var valid_598076 = query.getOrDefault("callback")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "callback", valid_598076
  var valid_598077 = query.getOrDefault("access_token")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "access_token", valid_598077
  var valid_598078 = query.getOrDefault("uploadType")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "uploadType", valid_598078
  var valid_598079 = query.getOrDefault("key")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "key", valid_598079
  var valid_598080 = query.getOrDefault("$.xgafv")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = newJString("1"))
  if valid_598080 != nil:
    section.add "$.xgafv", valid_598080
  var valid_598081 = query.getOrDefault("pageSize")
  valid_598081 = validateParameter(valid_598081, JInt, required = false, default = nil)
  if valid_598081 != nil:
    section.add "pageSize", valid_598081
  var valid_598082 = query.getOrDefault("prettyPrint")
  valid_598082 = validateParameter(valid_598082, JBool, required = false,
                                 default = newJBool(true))
  if valid_598082 != nil:
    section.add "prettyPrint", valid_598082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598083: Call_CloudidentityGroupsMembershipsList_598065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Memberships within a Group.
  ## 
  let valid = call_598083.validator(path, query, header, formData, body)
  let scheme = call_598083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598083.url(scheme.get, call_598083.host, call_598083.base,
                         call_598083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598083, url, valid)

proc call*(call_598084: Call_CloudidentityGroupsMembershipsList_598065;
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
  var path_598085 = newJObject()
  var query_598086 = newJObject()
  add(query_598086, "upload_protocol", newJString(uploadProtocol))
  add(query_598086, "fields", newJString(fields))
  add(query_598086, "pageToken", newJString(pageToken))
  add(query_598086, "quotaUser", newJString(quotaUser))
  add(query_598086, "view", newJString(view))
  add(query_598086, "alt", newJString(alt))
  add(query_598086, "oauth_token", newJString(oauthToken))
  add(query_598086, "callback", newJString(callback))
  add(query_598086, "access_token", newJString(accessToken))
  add(query_598086, "uploadType", newJString(uploadType))
  add(path_598085, "parent", newJString(parent))
  add(query_598086, "key", newJString(key))
  add(query_598086, "$.xgafv", newJString(Xgafv))
  add(query_598086, "pageSize", newJInt(pageSize))
  add(query_598086, "prettyPrint", newJBool(prettyPrint))
  result = call_598084.call(path_598085, query_598086, nil, nil, nil)

var cloudidentityGroupsMembershipsList* = Call_CloudidentityGroupsMembershipsList_598065(
    name: "cloudidentityGroupsMembershipsList", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/{parent}/memberships",
    validator: validate_CloudidentityGroupsMembershipsList_598066, base: "/",
    url: url_CloudidentityGroupsMembershipsList_598067, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsLookup_598108 = ref object of OpenApiRestCall_597408
proc url_CloudidentityGroupsMembershipsLookup_598110(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudidentityGroupsMembershipsLookup_598109(path: JsonNode;
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
  var valid_598111 = path.getOrDefault("parent")
  valid_598111 = validateParameter(valid_598111, JString, required = true,
                                 default = nil)
  if valid_598111 != nil:
    section.add "parent", valid_598111
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
  var valid_598112 = query.getOrDefault("upload_protocol")
  valid_598112 = validateParameter(valid_598112, JString, required = false,
                                 default = nil)
  if valid_598112 != nil:
    section.add "upload_protocol", valid_598112
  var valid_598113 = query.getOrDefault("fields")
  valid_598113 = validateParameter(valid_598113, JString, required = false,
                                 default = nil)
  if valid_598113 != nil:
    section.add "fields", valid_598113
  var valid_598114 = query.getOrDefault("quotaUser")
  valid_598114 = validateParameter(valid_598114, JString, required = false,
                                 default = nil)
  if valid_598114 != nil:
    section.add "quotaUser", valid_598114
  var valid_598115 = query.getOrDefault("alt")
  valid_598115 = validateParameter(valid_598115, JString, required = false,
                                 default = newJString("json"))
  if valid_598115 != nil:
    section.add "alt", valid_598115
  var valid_598116 = query.getOrDefault("oauth_token")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = nil)
  if valid_598116 != nil:
    section.add "oauth_token", valid_598116
  var valid_598117 = query.getOrDefault("callback")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "callback", valid_598117
  var valid_598118 = query.getOrDefault("access_token")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = nil)
  if valid_598118 != nil:
    section.add "access_token", valid_598118
  var valid_598119 = query.getOrDefault("uploadType")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = nil)
  if valid_598119 != nil:
    section.add "uploadType", valid_598119
  var valid_598120 = query.getOrDefault("memberKey.namespace")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = nil)
  if valid_598120 != nil:
    section.add "memberKey.namespace", valid_598120
  var valid_598121 = query.getOrDefault("key")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "key", valid_598121
  var valid_598122 = query.getOrDefault("$.xgafv")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = newJString("1"))
  if valid_598122 != nil:
    section.add "$.xgafv", valid_598122
  var valid_598123 = query.getOrDefault("memberKey.id")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "memberKey.id", valid_598123
  var valid_598124 = query.getOrDefault("prettyPrint")
  valid_598124 = validateParameter(valid_598124, JBool, required = false,
                                 default = newJBool(true))
  if valid_598124 != nil:
    section.add "prettyPrint", valid_598124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598125: Call_CloudidentityGroupsMembershipsLookup_598108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Membership
  ## within a Group by member's EntityKey.
  ## 
  let valid = call_598125.validator(path, query, header, formData, body)
  let scheme = call_598125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598125.url(scheme.get, call_598125.host, call_598125.base,
                         call_598125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598125, url, valid)

proc call*(call_598126: Call_CloudidentityGroupsMembershipsLookup_598108;
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
  var path_598127 = newJObject()
  var query_598128 = newJObject()
  add(query_598128, "upload_protocol", newJString(uploadProtocol))
  add(query_598128, "fields", newJString(fields))
  add(query_598128, "quotaUser", newJString(quotaUser))
  add(query_598128, "alt", newJString(alt))
  add(query_598128, "oauth_token", newJString(oauthToken))
  add(query_598128, "callback", newJString(callback))
  add(query_598128, "access_token", newJString(accessToken))
  add(query_598128, "uploadType", newJString(uploadType))
  add(path_598127, "parent", newJString(parent))
  add(query_598128, "memberKey.namespace", newJString(memberKeyNamespace))
  add(query_598128, "key", newJString(key))
  add(query_598128, "$.xgafv", newJString(Xgafv))
  add(query_598128, "memberKey.id", newJString(memberKeyId))
  add(query_598128, "prettyPrint", newJBool(prettyPrint))
  result = call_598126.call(path_598127, query_598128, nil, nil, nil)

var cloudidentityGroupsMembershipsLookup* = Call_CloudidentityGroupsMembershipsLookup_598108(
    name: "cloudidentityGroupsMembershipsLookup", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com",
    route: "/v1beta1/{parent}/memberships:lookup",
    validator: validate_CloudidentityGroupsMembershipsLookup_598109, base: "/",
    url: url_CloudidentityGroupsMembershipsLookup_598110, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
