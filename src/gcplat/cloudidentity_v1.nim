
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  Call_CloudidentityGroupsCreate_597953 = ref object of OpenApiRestCall_597408
proc url_CloudidentityGroupsCreate_597955(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsCreate_597954(path: JsonNode; query: JsonNode;
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
  var valid_597956 = query.getOrDefault("upload_protocol")
  valid_597956 = validateParameter(valid_597956, JString, required = false,
                                 default = nil)
  if valid_597956 != nil:
    section.add "upload_protocol", valid_597956
  var valid_597957 = query.getOrDefault("fields")
  valid_597957 = validateParameter(valid_597957, JString, required = false,
                                 default = nil)
  if valid_597957 != nil:
    section.add "fields", valid_597957
  var valid_597958 = query.getOrDefault("quotaUser")
  valid_597958 = validateParameter(valid_597958, JString, required = false,
                                 default = nil)
  if valid_597958 != nil:
    section.add "quotaUser", valid_597958
  var valid_597959 = query.getOrDefault("alt")
  valid_597959 = validateParameter(valid_597959, JString, required = false,
                                 default = newJString("json"))
  if valid_597959 != nil:
    section.add "alt", valid_597959
  var valid_597960 = query.getOrDefault("oauth_token")
  valid_597960 = validateParameter(valid_597960, JString, required = false,
                                 default = nil)
  if valid_597960 != nil:
    section.add "oauth_token", valid_597960
  var valid_597961 = query.getOrDefault("callback")
  valid_597961 = validateParameter(valid_597961, JString, required = false,
                                 default = nil)
  if valid_597961 != nil:
    section.add "callback", valid_597961
  var valid_597962 = query.getOrDefault("access_token")
  valid_597962 = validateParameter(valid_597962, JString, required = false,
                                 default = nil)
  if valid_597962 != nil:
    section.add "access_token", valid_597962
  var valid_597963 = query.getOrDefault("uploadType")
  valid_597963 = validateParameter(valid_597963, JString, required = false,
                                 default = nil)
  if valid_597963 != nil:
    section.add "uploadType", valid_597963
  var valid_597964 = query.getOrDefault("key")
  valid_597964 = validateParameter(valid_597964, JString, required = false,
                                 default = nil)
  if valid_597964 != nil:
    section.add "key", valid_597964
  var valid_597965 = query.getOrDefault("$.xgafv")
  valid_597965 = validateParameter(valid_597965, JString, required = false,
                                 default = newJString("1"))
  if valid_597965 != nil:
    section.add "$.xgafv", valid_597965
  var valid_597966 = query.getOrDefault("prettyPrint")
  valid_597966 = validateParameter(valid_597966, JBool, required = false,
                                 default = newJBool(true))
  if valid_597966 != nil:
    section.add "prettyPrint", valid_597966
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

proc call*(call_597968: Call_CloudidentityGroupsCreate_597953; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Group.
  ## 
  let valid = call_597968.validator(path, query, header, formData, body)
  let scheme = call_597968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597968.url(scheme.get, call_597968.host, call_597968.base,
                         call_597968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597968, url, valid)

proc call*(call_597969: Call_CloudidentityGroupsCreate_597953;
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
  var query_597970 = newJObject()
  var body_597971 = newJObject()
  add(query_597970, "upload_protocol", newJString(uploadProtocol))
  add(query_597970, "fields", newJString(fields))
  add(query_597970, "quotaUser", newJString(quotaUser))
  add(query_597970, "alt", newJString(alt))
  add(query_597970, "oauth_token", newJString(oauthToken))
  add(query_597970, "callback", newJString(callback))
  add(query_597970, "access_token", newJString(accessToken))
  add(query_597970, "uploadType", newJString(uploadType))
  add(query_597970, "key", newJString(key))
  add(query_597970, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597971 = body
  add(query_597970, "prettyPrint", newJBool(prettyPrint))
  result = call_597969.call(nil, query_597970, nil, nil, body_597971)

var cloudidentityGroupsCreate* = Call_CloudidentityGroupsCreate_597953(
    name: "cloudidentityGroupsCreate", meth: HttpMethod.HttpPost,
    host: "cloudidentity.googleapis.com", route: "/v1/groups",
    validator: validate_CloudidentityGroupsCreate_597954, base: "/",
    url: url_CloudidentityGroupsCreate_597955, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsList_597677 = ref object of OpenApiRestCall_597408
proc url_CloudidentityGroupsList_597679(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsList_597678(path: JsonNode; query: JsonNode;
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
  var valid_597793 = query.getOrDefault("pageToken")
  valid_597793 = validateParameter(valid_597793, JString, required = false,
                                 default = nil)
  if valid_597793 != nil:
    section.add "pageToken", valid_597793
  var valid_597794 = query.getOrDefault("quotaUser")
  valid_597794 = validateParameter(valid_597794, JString, required = false,
                                 default = nil)
  if valid_597794 != nil:
    section.add "quotaUser", valid_597794
  var valid_597808 = query.getOrDefault("view")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_597808 != nil:
    section.add "view", valid_597808
  var valid_597809 = query.getOrDefault("alt")
  valid_597809 = validateParameter(valid_597809, JString, required = false,
                                 default = newJString("json"))
  if valid_597809 != nil:
    section.add "alt", valid_597809
  var valid_597810 = query.getOrDefault("oauth_token")
  valid_597810 = validateParameter(valid_597810, JString, required = false,
                                 default = nil)
  if valid_597810 != nil:
    section.add "oauth_token", valid_597810
  var valid_597811 = query.getOrDefault("callback")
  valid_597811 = validateParameter(valid_597811, JString, required = false,
                                 default = nil)
  if valid_597811 != nil:
    section.add "callback", valid_597811
  var valid_597812 = query.getOrDefault("access_token")
  valid_597812 = validateParameter(valid_597812, JString, required = false,
                                 default = nil)
  if valid_597812 != nil:
    section.add "access_token", valid_597812
  var valid_597813 = query.getOrDefault("uploadType")
  valid_597813 = validateParameter(valid_597813, JString, required = false,
                                 default = nil)
  if valid_597813 != nil:
    section.add "uploadType", valid_597813
  var valid_597814 = query.getOrDefault("parent")
  valid_597814 = validateParameter(valid_597814, JString, required = false,
                                 default = nil)
  if valid_597814 != nil:
    section.add "parent", valid_597814
  var valid_597815 = query.getOrDefault("key")
  valid_597815 = validateParameter(valid_597815, JString, required = false,
                                 default = nil)
  if valid_597815 != nil:
    section.add "key", valid_597815
  var valid_597816 = query.getOrDefault("$.xgafv")
  valid_597816 = validateParameter(valid_597816, JString, required = false,
                                 default = newJString("1"))
  if valid_597816 != nil:
    section.add "$.xgafv", valid_597816
  var valid_597817 = query.getOrDefault("pageSize")
  valid_597817 = validateParameter(valid_597817, JInt, required = false, default = nil)
  if valid_597817 != nil:
    section.add "pageSize", valid_597817
  var valid_597818 = query.getOrDefault("prettyPrint")
  valid_597818 = validateParameter(valid_597818, JBool, required = false,
                                 default = newJBool(true))
  if valid_597818 != nil:
    section.add "prettyPrint", valid_597818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597841: Call_CloudidentityGroupsList_597677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List groups within a customer or a domain.
  ## 
  let valid = call_597841.validator(path, query, header, formData, body)
  let scheme = call_597841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597841.url(scheme.get, call_597841.host, call_597841.base,
                         call_597841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597841, url, valid)

proc call*(call_597912: Call_CloudidentityGroupsList_597677;
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
  var query_597913 = newJObject()
  add(query_597913, "upload_protocol", newJString(uploadProtocol))
  add(query_597913, "fields", newJString(fields))
  add(query_597913, "pageToken", newJString(pageToken))
  add(query_597913, "quotaUser", newJString(quotaUser))
  add(query_597913, "view", newJString(view))
  add(query_597913, "alt", newJString(alt))
  add(query_597913, "oauth_token", newJString(oauthToken))
  add(query_597913, "callback", newJString(callback))
  add(query_597913, "access_token", newJString(accessToken))
  add(query_597913, "uploadType", newJString(uploadType))
  add(query_597913, "parent", newJString(parent))
  add(query_597913, "key", newJString(key))
  add(query_597913, "$.xgafv", newJString(Xgafv))
  add(query_597913, "pageSize", newJInt(pageSize))
  add(query_597913, "prettyPrint", newJBool(prettyPrint))
  result = call_597912.call(nil, query_597913, nil, nil, nil)

var cloudidentityGroupsList* = Call_CloudidentityGroupsList_597677(
    name: "cloudidentityGroupsList", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1/groups",
    validator: validate_CloudidentityGroupsList_597678, base: "/",
    url: url_CloudidentityGroupsList_597679, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsLookup_597972 = ref object of OpenApiRestCall_597408
proc url_CloudidentityGroupsLookup_597974(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsLookup_597973(path: JsonNode; query: JsonNode;
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
  var valid_597975 = query.getOrDefault("upload_protocol")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "upload_protocol", valid_597975
  var valid_597976 = query.getOrDefault("fields")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "fields", valid_597976
  var valid_597977 = query.getOrDefault("quotaUser")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "quotaUser", valid_597977
  var valid_597978 = query.getOrDefault("alt")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = newJString("json"))
  if valid_597978 != nil:
    section.add "alt", valid_597978
  var valid_597979 = query.getOrDefault("oauth_token")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = nil)
  if valid_597979 != nil:
    section.add "oauth_token", valid_597979
  var valid_597980 = query.getOrDefault("callback")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "callback", valid_597980
  var valid_597981 = query.getOrDefault("access_token")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "access_token", valid_597981
  var valid_597982 = query.getOrDefault("uploadType")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = nil)
  if valid_597982 != nil:
    section.add "uploadType", valid_597982
  var valid_597983 = query.getOrDefault("groupKey.namespace")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = nil)
  if valid_597983 != nil:
    section.add "groupKey.namespace", valid_597983
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
  var valid_597986 = query.getOrDefault("prettyPrint")
  valid_597986 = validateParameter(valid_597986, JBool, required = false,
                                 default = newJBool(true))
  if valid_597986 != nil:
    section.add "prettyPrint", valid_597986
  var valid_597987 = query.getOrDefault("groupKey.id")
  valid_597987 = validateParameter(valid_597987, JString, required = false,
                                 default = nil)
  if valid_597987 != nil:
    section.add "groupKey.id", valid_597987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597988: Call_CloudidentityGroupsLookup_597972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Group by
  ## its EntityKey.
  ## 
  let valid = call_597988.validator(path, query, header, formData, body)
  let scheme = call_597988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597988.url(scheme.get, call_597988.host, call_597988.base,
                         call_597988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597988, url, valid)

proc call*(call_597989: Call_CloudidentityGroupsLookup_597972;
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
  var query_597990 = newJObject()
  add(query_597990, "upload_protocol", newJString(uploadProtocol))
  add(query_597990, "fields", newJString(fields))
  add(query_597990, "quotaUser", newJString(quotaUser))
  add(query_597990, "alt", newJString(alt))
  add(query_597990, "oauth_token", newJString(oauthToken))
  add(query_597990, "callback", newJString(callback))
  add(query_597990, "access_token", newJString(accessToken))
  add(query_597990, "uploadType", newJString(uploadType))
  add(query_597990, "groupKey.namespace", newJString(groupKeyNamespace))
  add(query_597990, "key", newJString(key))
  add(query_597990, "$.xgafv", newJString(Xgafv))
  add(query_597990, "prettyPrint", newJBool(prettyPrint))
  add(query_597990, "groupKey.id", newJString(groupKeyId))
  result = call_597989.call(nil, query_597990, nil, nil, nil)

var cloudidentityGroupsLookup* = Call_CloudidentityGroupsLookup_597972(
    name: "cloudidentityGroupsLookup", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1/groups:lookup",
    validator: validate_CloudidentityGroupsLookup_597973, base: "/",
    url: url_CloudidentityGroupsLookup_597974, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsSearch_597991 = ref object of OpenApiRestCall_597408
proc url_CloudidentityGroupsSearch_597993(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsSearch_597992(path: JsonNode; query: JsonNode;
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
  var valid_597994 = query.getOrDefault("upload_protocol")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "upload_protocol", valid_597994
  var valid_597995 = query.getOrDefault("fields")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "fields", valid_597995
  var valid_597996 = query.getOrDefault("pageToken")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "pageToken", valid_597996
  var valid_597997 = query.getOrDefault("quotaUser")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "quotaUser", valid_597997
  var valid_597998 = query.getOrDefault("view")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_597998 != nil:
    section.add "view", valid_597998
  var valid_597999 = query.getOrDefault("alt")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = newJString("json"))
  if valid_597999 != nil:
    section.add "alt", valid_597999
  var valid_598000 = query.getOrDefault("query")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "query", valid_598000
  var valid_598001 = query.getOrDefault("oauth_token")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = nil)
  if valid_598001 != nil:
    section.add "oauth_token", valid_598001
  var valid_598002 = query.getOrDefault("callback")
  valid_598002 = validateParameter(valid_598002, JString, required = false,
                                 default = nil)
  if valid_598002 != nil:
    section.add "callback", valid_598002
  var valid_598003 = query.getOrDefault("access_token")
  valid_598003 = validateParameter(valid_598003, JString, required = false,
                                 default = nil)
  if valid_598003 != nil:
    section.add "access_token", valid_598003
  var valid_598004 = query.getOrDefault("uploadType")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = nil)
  if valid_598004 != nil:
    section.add "uploadType", valid_598004
  var valid_598005 = query.getOrDefault("key")
  valid_598005 = validateParameter(valid_598005, JString, required = false,
                                 default = nil)
  if valid_598005 != nil:
    section.add "key", valid_598005
  var valid_598006 = query.getOrDefault("$.xgafv")
  valid_598006 = validateParameter(valid_598006, JString, required = false,
                                 default = newJString("1"))
  if valid_598006 != nil:
    section.add "$.xgafv", valid_598006
  var valid_598007 = query.getOrDefault("pageSize")
  valid_598007 = validateParameter(valid_598007, JInt, required = false, default = nil)
  if valid_598007 != nil:
    section.add "pageSize", valid_598007
  var valid_598008 = query.getOrDefault("prettyPrint")
  valid_598008 = validateParameter(valid_598008, JBool, required = false,
                                 default = newJBool(true))
  if valid_598008 != nil:
    section.add "prettyPrint", valid_598008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598009: Call_CloudidentityGroupsSearch_597991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for Groups.
  ## 
  let valid = call_598009.validator(path, query, header, formData, body)
  let scheme = call_598009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598009.url(scheme.get, call_598009.host, call_598009.base,
                         call_598009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598009, url, valid)

proc call*(call_598010: Call_CloudidentityGroupsSearch_597991;
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
  var query_598011 = newJObject()
  add(query_598011, "upload_protocol", newJString(uploadProtocol))
  add(query_598011, "fields", newJString(fields))
  add(query_598011, "pageToken", newJString(pageToken))
  add(query_598011, "quotaUser", newJString(quotaUser))
  add(query_598011, "view", newJString(view))
  add(query_598011, "alt", newJString(alt))
  add(query_598011, "query", newJString(query))
  add(query_598011, "oauth_token", newJString(oauthToken))
  add(query_598011, "callback", newJString(callback))
  add(query_598011, "access_token", newJString(accessToken))
  add(query_598011, "uploadType", newJString(uploadType))
  add(query_598011, "key", newJString(key))
  add(query_598011, "$.xgafv", newJString(Xgafv))
  add(query_598011, "pageSize", newJInt(pageSize))
  add(query_598011, "prettyPrint", newJBool(prettyPrint))
  result = call_598010.call(nil, query_598011, nil, nil, nil)

var cloudidentityGroupsSearch* = Call_CloudidentityGroupsSearch_597991(
    name: "cloudidentityGroupsSearch", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1/groups:search",
    validator: validate_CloudidentityGroupsSearch_597992, base: "/",
    url: url_CloudidentityGroupsSearch_597993, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsGet_598012 = ref object of OpenApiRestCall_597408
proc url_CloudidentityGroupsMembershipsGet_598014(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsMembershipsGet_598013(path: JsonNode;
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
  var valid_598029 = path.getOrDefault("name")
  valid_598029 = validateParameter(valid_598029, JString, required = true,
                                 default = nil)
  if valid_598029 != nil:
    section.add "name", valid_598029
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
  var valid_598030 = query.getOrDefault("upload_protocol")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "upload_protocol", valid_598030
  var valid_598031 = query.getOrDefault("fields")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "fields", valid_598031
  var valid_598032 = query.getOrDefault("quotaUser")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "quotaUser", valid_598032
  var valid_598033 = query.getOrDefault("alt")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = newJString("json"))
  if valid_598033 != nil:
    section.add "alt", valid_598033
  var valid_598034 = query.getOrDefault("oauth_token")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "oauth_token", valid_598034
  var valid_598035 = query.getOrDefault("callback")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "callback", valid_598035
  var valid_598036 = query.getOrDefault("access_token")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "access_token", valid_598036
  var valid_598037 = query.getOrDefault("uploadType")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "uploadType", valid_598037
  var valid_598038 = query.getOrDefault("key")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "key", valid_598038
  var valid_598039 = query.getOrDefault("$.xgafv")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = newJString("1"))
  if valid_598039 != nil:
    section.add "$.xgafv", valid_598039
  var valid_598040 = query.getOrDefault("prettyPrint")
  valid_598040 = validateParameter(valid_598040, JBool, required = false,
                                 default = newJBool(true))
  if valid_598040 != nil:
    section.add "prettyPrint", valid_598040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598041: Call_CloudidentityGroupsMembershipsGet_598012;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a Membership.
  ## 
  let valid = call_598041.validator(path, query, header, formData, body)
  let scheme = call_598041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598041.url(scheme.get, call_598041.host, call_598041.base,
                         call_598041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598041, url, valid)

proc call*(call_598042: Call_CloudidentityGroupsMembershipsGet_598012;
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
  var path_598043 = newJObject()
  var query_598044 = newJObject()
  add(query_598044, "upload_protocol", newJString(uploadProtocol))
  add(query_598044, "fields", newJString(fields))
  add(query_598044, "quotaUser", newJString(quotaUser))
  add(path_598043, "name", newJString(name))
  add(query_598044, "alt", newJString(alt))
  add(query_598044, "oauth_token", newJString(oauthToken))
  add(query_598044, "callback", newJString(callback))
  add(query_598044, "access_token", newJString(accessToken))
  add(query_598044, "uploadType", newJString(uploadType))
  add(query_598044, "key", newJString(key))
  add(query_598044, "$.xgafv", newJString(Xgafv))
  add(query_598044, "prettyPrint", newJBool(prettyPrint))
  result = call_598042.call(path_598043, query_598044, nil, nil, nil)

var cloudidentityGroupsMembershipsGet* = Call_CloudidentityGroupsMembershipsGet_598012(
    name: "cloudidentityGroupsMembershipsGet", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudidentityGroupsMembershipsGet_598013, base: "/",
    url: url_CloudidentityGroupsMembershipsGet_598014, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsPatch_598064 = ref object of OpenApiRestCall_597408
proc url_CloudidentityGroupsPatch_598066(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsPatch_598065(path: JsonNode; query: JsonNode;
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
  var valid_598067 = path.getOrDefault("name")
  valid_598067 = validateParameter(valid_598067, JString, required = true,
                                 default = nil)
  if valid_598067 != nil:
    section.add "name", valid_598067
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
  var valid_598068 = query.getOrDefault("upload_protocol")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = nil)
  if valid_598068 != nil:
    section.add "upload_protocol", valid_598068
  var valid_598069 = query.getOrDefault("fields")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = nil)
  if valid_598069 != nil:
    section.add "fields", valid_598069
  var valid_598070 = query.getOrDefault("quotaUser")
  valid_598070 = validateParameter(valid_598070, JString, required = false,
                                 default = nil)
  if valid_598070 != nil:
    section.add "quotaUser", valid_598070
  var valid_598071 = query.getOrDefault("alt")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = newJString("json"))
  if valid_598071 != nil:
    section.add "alt", valid_598071
  var valid_598072 = query.getOrDefault("oauth_token")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "oauth_token", valid_598072
  var valid_598073 = query.getOrDefault("callback")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "callback", valid_598073
  var valid_598074 = query.getOrDefault("access_token")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "access_token", valid_598074
  var valid_598075 = query.getOrDefault("uploadType")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "uploadType", valid_598075
  var valid_598076 = query.getOrDefault("key")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "key", valid_598076
  var valid_598077 = query.getOrDefault("$.xgafv")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = newJString("1"))
  if valid_598077 != nil:
    section.add "$.xgafv", valid_598077
  var valid_598078 = query.getOrDefault("prettyPrint")
  valid_598078 = validateParameter(valid_598078, JBool, required = false,
                                 default = newJBool(true))
  if valid_598078 != nil:
    section.add "prettyPrint", valid_598078
  var valid_598079 = query.getOrDefault("updateMask")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "updateMask", valid_598079
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

proc call*(call_598081: Call_CloudidentityGroupsPatch_598064; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Group.
  ## 
  let valid = call_598081.validator(path, query, header, formData, body)
  let scheme = call_598081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598081.url(scheme.get, call_598081.host, call_598081.base,
                         call_598081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598081, url, valid)

proc call*(call_598082: Call_CloudidentityGroupsPatch_598064; name: string;
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
  var path_598083 = newJObject()
  var query_598084 = newJObject()
  var body_598085 = newJObject()
  add(query_598084, "upload_protocol", newJString(uploadProtocol))
  add(query_598084, "fields", newJString(fields))
  add(query_598084, "quotaUser", newJString(quotaUser))
  add(path_598083, "name", newJString(name))
  add(query_598084, "alt", newJString(alt))
  add(query_598084, "oauth_token", newJString(oauthToken))
  add(query_598084, "callback", newJString(callback))
  add(query_598084, "access_token", newJString(accessToken))
  add(query_598084, "uploadType", newJString(uploadType))
  add(query_598084, "key", newJString(key))
  add(query_598084, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598085 = body
  add(query_598084, "prettyPrint", newJBool(prettyPrint))
  add(query_598084, "updateMask", newJString(updateMask))
  result = call_598082.call(path_598083, query_598084, nil, nil, body_598085)

var cloudidentityGroupsPatch* = Call_CloudidentityGroupsPatch_598064(
    name: "cloudidentityGroupsPatch", meth: HttpMethod.HttpPatch,
    host: "cloudidentity.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudidentityGroupsPatch_598065, base: "/",
    url: url_CloudidentityGroupsPatch_598066, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsDelete_598045 = ref object of OpenApiRestCall_597408
proc url_CloudidentityGroupsMembershipsDelete_598047(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudidentityGroupsMembershipsDelete_598046(path: JsonNode;
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
  var valid_598048 = path.getOrDefault("name")
  valid_598048 = validateParameter(valid_598048, JString, required = true,
                                 default = nil)
  if valid_598048 != nil:
    section.add "name", valid_598048
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
  var valid_598049 = query.getOrDefault("upload_protocol")
  valid_598049 = validateParameter(valid_598049, JString, required = false,
                                 default = nil)
  if valid_598049 != nil:
    section.add "upload_protocol", valid_598049
  var valid_598050 = query.getOrDefault("fields")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = nil)
  if valid_598050 != nil:
    section.add "fields", valid_598050
  var valid_598051 = query.getOrDefault("quotaUser")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = nil)
  if valid_598051 != nil:
    section.add "quotaUser", valid_598051
  var valid_598052 = query.getOrDefault("alt")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = newJString("json"))
  if valid_598052 != nil:
    section.add "alt", valid_598052
  var valid_598053 = query.getOrDefault("oauth_token")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "oauth_token", valid_598053
  var valid_598054 = query.getOrDefault("callback")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "callback", valid_598054
  var valid_598055 = query.getOrDefault("access_token")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "access_token", valid_598055
  var valid_598056 = query.getOrDefault("uploadType")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "uploadType", valid_598056
  var valid_598057 = query.getOrDefault("key")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "key", valid_598057
  var valid_598058 = query.getOrDefault("$.xgafv")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = newJString("1"))
  if valid_598058 != nil:
    section.add "$.xgafv", valid_598058
  var valid_598059 = query.getOrDefault("prettyPrint")
  valid_598059 = validateParameter(valid_598059, JBool, required = false,
                                 default = newJBool(true))
  if valid_598059 != nil:
    section.add "prettyPrint", valid_598059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598060: Call_CloudidentityGroupsMembershipsDelete_598045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a Membership.
  ## 
  let valid = call_598060.validator(path, query, header, formData, body)
  let scheme = call_598060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598060.url(scheme.get, call_598060.host, call_598060.base,
                         call_598060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598060, url, valid)

proc call*(call_598061: Call_CloudidentityGroupsMembershipsDelete_598045;
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
  var path_598062 = newJObject()
  var query_598063 = newJObject()
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
  add(query_598063, "prettyPrint", newJBool(prettyPrint))
  result = call_598061.call(path_598062, query_598063, nil, nil, nil)

var cloudidentityGroupsMembershipsDelete* = Call_CloudidentityGroupsMembershipsDelete_598045(
    name: "cloudidentityGroupsMembershipsDelete", meth: HttpMethod.HttpDelete,
    host: "cloudidentity.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudidentityGroupsMembershipsDelete_598046, base: "/",
    url: url_CloudidentityGroupsMembershipsDelete_598047, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsCreate_598108 = ref object of OpenApiRestCall_597408
proc url_CloudidentityGroupsMembershipsCreate_598110(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudidentityGroupsMembershipsCreate_598109(path: JsonNode;
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
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
  var valid_598120 = query.getOrDefault("key")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = nil)
  if valid_598120 != nil:
    section.add "key", valid_598120
  var valid_598121 = query.getOrDefault("$.xgafv")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = newJString("1"))
  if valid_598121 != nil:
    section.add "$.xgafv", valid_598121
  var valid_598122 = query.getOrDefault("prettyPrint")
  valid_598122 = validateParameter(valid_598122, JBool, required = false,
                                 default = newJBool(true))
  if valid_598122 != nil:
    section.add "prettyPrint", valid_598122
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

proc call*(call_598124: Call_CloudidentityGroupsMembershipsCreate_598108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Membership.
  ## 
  let valid = call_598124.validator(path, query, header, formData, body)
  let scheme = call_598124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598124.url(scheme.get, call_598124.host, call_598124.base,
                         call_598124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598124, url, valid)

proc call*(call_598125: Call_CloudidentityGroupsMembershipsCreate_598108;
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
  var path_598126 = newJObject()
  var query_598127 = newJObject()
  var body_598128 = newJObject()
  add(query_598127, "upload_protocol", newJString(uploadProtocol))
  add(query_598127, "fields", newJString(fields))
  add(query_598127, "quotaUser", newJString(quotaUser))
  add(query_598127, "alt", newJString(alt))
  add(query_598127, "oauth_token", newJString(oauthToken))
  add(query_598127, "callback", newJString(callback))
  add(query_598127, "access_token", newJString(accessToken))
  add(query_598127, "uploadType", newJString(uploadType))
  add(path_598126, "parent", newJString(parent))
  add(query_598127, "key", newJString(key))
  add(query_598127, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598128 = body
  add(query_598127, "prettyPrint", newJBool(prettyPrint))
  result = call_598125.call(path_598126, query_598127, nil, nil, body_598128)

var cloudidentityGroupsMembershipsCreate* = Call_CloudidentityGroupsMembershipsCreate_598108(
    name: "cloudidentityGroupsMembershipsCreate", meth: HttpMethod.HttpPost,
    host: "cloudidentity.googleapis.com", route: "/v1/{parent}/memberships",
    validator: validate_CloudidentityGroupsMembershipsCreate_598109, base: "/",
    url: url_CloudidentityGroupsMembershipsCreate_598110, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsList_598086 = ref object of OpenApiRestCall_597408
proc url_CloudidentityGroupsMembershipsList_598088(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudidentityGroupsMembershipsList_598087(path: JsonNode;
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
  var valid_598089 = path.getOrDefault("parent")
  valid_598089 = validateParameter(valid_598089, JString, required = true,
                                 default = nil)
  if valid_598089 != nil:
    section.add "parent", valid_598089
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
  var valid_598090 = query.getOrDefault("upload_protocol")
  valid_598090 = validateParameter(valid_598090, JString, required = false,
                                 default = nil)
  if valid_598090 != nil:
    section.add "upload_protocol", valid_598090
  var valid_598091 = query.getOrDefault("fields")
  valid_598091 = validateParameter(valid_598091, JString, required = false,
                                 default = nil)
  if valid_598091 != nil:
    section.add "fields", valid_598091
  var valid_598092 = query.getOrDefault("pageToken")
  valid_598092 = validateParameter(valid_598092, JString, required = false,
                                 default = nil)
  if valid_598092 != nil:
    section.add "pageToken", valid_598092
  var valid_598093 = query.getOrDefault("quotaUser")
  valid_598093 = validateParameter(valid_598093, JString, required = false,
                                 default = nil)
  if valid_598093 != nil:
    section.add "quotaUser", valid_598093
  var valid_598094 = query.getOrDefault("view")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_598094 != nil:
    section.add "view", valid_598094
  var valid_598095 = query.getOrDefault("alt")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = newJString("json"))
  if valid_598095 != nil:
    section.add "alt", valid_598095
  var valid_598096 = query.getOrDefault("oauth_token")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "oauth_token", valid_598096
  var valid_598097 = query.getOrDefault("callback")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "callback", valid_598097
  var valid_598098 = query.getOrDefault("access_token")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = nil)
  if valid_598098 != nil:
    section.add "access_token", valid_598098
  var valid_598099 = query.getOrDefault("uploadType")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = nil)
  if valid_598099 != nil:
    section.add "uploadType", valid_598099
  var valid_598100 = query.getOrDefault("key")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "key", valid_598100
  var valid_598101 = query.getOrDefault("$.xgafv")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = newJString("1"))
  if valid_598101 != nil:
    section.add "$.xgafv", valid_598101
  var valid_598102 = query.getOrDefault("pageSize")
  valid_598102 = validateParameter(valid_598102, JInt, required = false, default = nil)
  if valid_598102 != nil:
    section.add "pageSize", valid_598102
  var valid_598103 = query.getOrDefault("prettyPrint")
  valid_598103 = validateParameter(valid_598103, JBool, required = false,
                                 default = newJBool(true))
  if valid_598103 != nil:
    section.add "prettyPrint", valid_598103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598104: Call_CloudidentityGroupsMembershipsList_598086;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Memberships within a Group.
  ## 
  let valid = call_598104.validator(path, query, header, formData, body)
  let scheme = call_598104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598104.url(scheme.get, call_598104.host, call_598104.base,
                         call_598104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598104, url, valid)

proc call*(call_598105: Call_CloudidentityGroupsMembershipsList_598086;
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
  var path_598106 = newJObject()
  var query_598107 = newJObject()
  add(query_598107, "upload_protocol", newJString(uploadProtocol))
  add(query_598107, "fields", newJString(fields))
  add(query_598107, "pageToken", newJString(pageToken))
  add(query_598107, "quotaUser", newJString(quotaUser))
  add(query_598107, "view", newJString(view))
  add(query_598107, "alt", newJString(alt))
  add(query_598107, "oauth_token", newJString(oauthToken))
  add(query_598107, "callback", newJString(callback))
  add(query_598107, "access_token", newJString(accessToken))
  add(query_598107, "uploadType", newJString(uploadType))
  add(path_598106, "parent", newJString(parent))
  add(query_598107, "key", newJString(key))
  add(query_598107, "$.xgafv", newJString(Xgafv))
  add(query_598107, "pageSize", newJInt(pageSize))
  add(query_598107, "prettyPrint", newJBool(prettyPrint))
  result = call_598105.call(path_598106, query_598107, nil, nil, nil)

var cloudidentityGroupsMembershipsList* = Call_CloudidentityGroupsMembershipsList_598086(
    name: "cloudidentityGroupsMembershipsList", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1/{parent}/memberships",
    validator: validate_CloudidentityGroupsMembershipsList_598087, base: "/",
    url: url_CloudidentityGroupsMembershipsList_598088, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsLookup_598129 = ref object of OpenApiRestCall_597408
proc url_CloudidentityGroupsMembershipsLookup_598131(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudidentityGroupsMembershipsLookup_598130(path: JsonNode;
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
  var valid_598132 = path.getOrDefault("parent")
  valid_598132 = validateParameter(valid_598132, JString, required = true,
                                 default = nil)
  if valid_598132 != nil:
    section.add "parent", valid_598132
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
  var valid_598133 = query.getOrDefault("upload_protocol")
  valid_598133 = validateParameter(valid_598133, JString, required = false,
                                 default = nil)
  if valid_598133 != nil:
    section.add "upload_protocol", valid_598133
  var valid_598134 = query.getOrDefault("fields")
  valid_598134 = validateParameter(valid_598134, JString, required = false,
                                 default = nil)
  if valid_598134 != nil:
    section.add "fields", valid_598134
  var valid_598135 = query.getOrDefault("quotaUser")
  valid_598135 = validateParameter(valid_598135, JString, required = false,
                                 default = nil)
  if valid_598135 != nil:
    section.add "quotaUser", valid_598135
  var valid_598136 = query.getOrDefault("alt")
  valid_598136 = validateParameter(valid_598136, JString, required = false,
                                 default = newJString("json"))
  if valid_598136 != nil:
    section.add "alt", valid_598136
  var valid_598137 = query.getOrDefault("oauth_token")
  valid_598137 = validateParameter(valid_598137, JString, required = false,
                                 default = nil)
  if valid_598137 != nil:
    section.add "oauth_token", valid_598137
  var valid_598138 = query.getOrDefault("callback")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = nil)
  if valid_598138 != nil:
    section.add "callback", valid_598138
  var valid_598139 = query.getOrDefault("access_token")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "access_token", valid_598139
  var valid_598140 = query.getOrDefault("uploadType")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = nil)
  if valid_598140 != nil:
    section.add "uploadType", valid_598140
  var valid_598141 = query.getOrDefault("memberKey.namespace")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = nil)
  if valid_598141 != nil:
    section.add "memberKey.namespace", valid_598141
  var valid_598142 = query.getOrDefault("key")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "key", valid_598142
  var valid_598143 = query.getOrDefault("$.xgafv")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = newJString("1"))
  if valid_598143 != nil:
    section.add "$.xgafv", valid_598143
  var valid_598144 = query.getOrDefault("memberKey.id")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = nil)
  if valid_598144 != nil:
    section.add "memberKey.id", valid_598144
  var valid_598145 = query.getOrDefault("prettyPrint")
  valid_598145 = validateParameter(valid_598145, JBool, required = false,
                                 default = newJBool(true))
  if valid_598145 != nil:
    section.add "prettyPrint", valid_598145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598146: Call_CloudidentityGroupsMembershipsLookup_598129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Membership
  ## within a Group by member's EntityKey.
  ## 
  let valid = call_598146.validator(path, query, header, formData, body)
  let scheme = call_598146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598146.url(scheme.get, call_598146.host, call_598146.base,
                         call_598146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598146, url, valid)

proc call*(call_598147: Call_CloudidentityGroupsMembershipsLookup_598129;
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
  var path_598148 = newJObject()
  var query_598149 = newJObject()
  add(query_598149, "upload_protocol", newJString(uploadProtocol))
  add(query_598149, "fields", newJString(fields))
  add(query_598149, "quotaUser", newJString(quotaUser))
  add(query_598149, "alt", newJString(alt))
  add(query_598149, "oauth_token", newJString(oauthToken))
  add(query_598149, "callback", newJString(callback))
  add(query_598149, "access_token", newJString(accessToken))
  add(query_598149, "uploadType", newJString(uploadType))
  add(path_598148, "parent", newJString(parent))
  add(query_598149, "memberKey.namespace", newJString(memberKeyNamespace))
  add(query_598149, "key", newJString(key))
  add(query_598149, "$.xgafv", newJString(Xgafv))
  add(query_598149, "memberKey.id", newJString(memberKeyId))
  add(query_598149, "prettyPrint", newJBool(prettyPrint))
  result = call_598147.call(path_598148, query_598149, nil, nil, nil)

var cloudidentityGroupsMembershipsLookup* = Call_CloudidentityGroupsMembershipsLookup_598129(
    name: "cloudidentityGroupsMembershipsLookup", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com",
    route: "/v1/{parent}/memberships:lookup",
    validator: validate_CloudidentityGroupsMembershipsLookup_598130, base: "/",
    url: url_CloudidentityGroupsMembershipsLookup_598131, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
