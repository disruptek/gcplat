
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
  gcpServiceName = "cloudidentity"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudidentityGroupsCreate_588986 = ref object of OpenApiRestCall_588441
proc url_CloudidentityGroupsCreate_588988(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsCreate_588987(path: JsonNode; query: JsonNode;
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
  var valid_588989 = query.getOrDefault("upload_protocol")
  valid_588989 = validateParameter(valid_588989, JString, required = false,
                                 default = nil)
  if valid_588989 != nil:
    section.add "upload_protocol", valid_588989
  var valid_588990 = query.getOrDefault("fields")
  valid_588990 = validateParameter(valid_588990, JString, required = false,
                                 default = nil)
  if valid_588990 != nil:
    section.add "fields", valid_588990
  var valid_588991 = query.getOrDefault("quotaUser")
  valid_588991 = validateParameter(valid_588991, JString, required = false,
                                 default = nil)
  if valid_588991 != nil:
    section.add "quotaUser", valid_588991
  var valid_588992 = query.getOrDefault("alt")
  valid_588992 = validateParameter(valid_588992, JString, required = false,
                                 default = newJString("json"))
  if valid_588992 != nil:
    section.add "alt", valid_588992
  var valid_588993 = query.getOrDefault("oauth_token")
  valid_588993 = validateParameter(valid_588993, JString, required = false,
                                 default = nil)
  if valid_588993 != nil:
    section.add "oauth_token", valid_588993
  var valid_588994 = query.getOrDefault("callback")
  valid_588994 = validateParameter(valid_588994, JString, required = false,
                                 default = nil)
  if valid_588994 != nil:
    section.add "callback", valid_588994
  var valid_588995 = query.getOrDefault("access_token")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = nil)
  if valid_588995 != nil:
    section.add "access_token", valid_588995
  var valid_588996 = query.getOrDefault("uploadType")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "uploadType", valid_588996
  var valid_588997 = query.getOrDefault("key")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "key", valid_588997
  var valid_588998 = query.getOrDefault("$.xgafv")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = newJString("1"))
  if valid_588998 != nil:
    section.add "$.xgafv", valid_588998
  var valid_588999 = query.getOrDefault("prettyPrint")
  valid_588999 = validateParameter(valid_588999, JBool, required = false,
                                 default = newJBool(true))
  if valid_588999 != nil:
    section.add "prettyPrint", valid_588999
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

proc call*(call_589001: Call_CloudidentityGroupsCreate_588986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Group.
  ## 
  let valid = call_589001.validator(path, query, header, formData, body)
  let scheme = call_589001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589001.url(scheme.get, call_589001.host, call_589001.base,
                         call_589001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589001, url, valid)

proc call*(call_589002: Call_CloudidentityGroupsCreate_588986;
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
  var query_589003 = newJObject()
  var body_589004 = newJObject()
  add(query_589003, "upload_protocol", newJString(uploadProtocol))
  add(query_589003, "fields", newJString(fields))
  add(query_589003, "quotaUser", newJString(quotaUser))
  add(query_589003, "alt", newJString(alt))
  add(query_589003, "oauth_token", newJString(oauthToken))
  add(query_589003, "callback", newJString(callback))
  add(query_589003, "access_token", newJString(accessToken))
  add(query_589003, "uploadType", newJString(uploadType))
  add(query_589003, "key", newJString(key))
  add(query_589003, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589004 = body
  add(query_589003, "prettyPrint", newJBool(prettyPrint))
  result = call_589002.call(nil, query_589003, nil, nil, body_589004)

var cloudidentityGroupsCreate* = Call_CloudidentityGroupsCreate_588986(
    name: "cloudidentityGroupsCreate", meth: HttpMethod.HttpPost,
    host: "cloudidentity.googleapis.com", route: "/v1/groups",
    validator: validate_CloudidentityGroupsCreate_588987, base: "/",
    url: url_CloudidentityGroupsCreate_588988, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsList_588710 = ref object of OpenApiRestCall_588441
proc url_CloudidentityGroupsList_588712(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsList_588711(path: JsonNode; query: JsonNode;
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
  var valid_588841 = query.getOrDefault("view")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_588841 != nil:
    section.add "view", valid_588841
  var valid_588842 = query.getOrDefault("alt")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = newJString("json"))
  if valid_588842 != nil:
    section.add "alt", valid_588842
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
  var valid_588847 = query.getOrDefault("parent")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = nil)
  if valid_588847 != nil:
    section.add "parent", valid_588847
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588874: Call_CloudidentityGroupsList_588710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List groups within a customer or a domain.
  ## 
  let valid = call_588874.validator(path, query, header, formData, body)
  let scheme = call_588874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588874.url(scheme.get, call_588874.host, call_588874.base,
                         call_588874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588874, url, valid)

proc call*(call_588945: Call_CloudidentityGroupsList_588710;
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
  var query_588946 = newJObject()
  add(query_588946, "upload_protocol", newJString(uploadProtocol))
  add(query_588946, "fields", newJString(fields))
  add(query_588946, "pageToken", newJString(pageToken))
  add(query_588946, "quotaUser", newJString(quotaUser))
  add(query_588946, "view", newJString(view))
  add(query_588946, "alt", newJString(alt))
  add(query_588946, "oauth_token", newJString(oauthToken))
  add(query_588946, "callback", newJString(callback))
  add(query_588946, "access_token", newJString(accessToken))
  add(query_588946, "uploadType", newJString(uploadType))
  add(query_588946, "parent", newJString(parent))
  add(query_588946, "key", newJString(key))
  add(query_588946, "$.xgafv", newJString(Xgafv))
  add(query_588946, "pageSize", newJInt(pageSize))
  add(query_588946, "prettyPrint", newJBool(prettyPrint))
  result = call_588945.call(nil, query_588946, nil, nil, nil)

var cloudidentityGroupsList* = Call_CloudidentityGroupsList_588710(
    name: "cloudidentityGroupsList", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1/groups",
    validator: validate_CloudidentityGroupsList_588711, base: "/",
    url: url_CloudidentityGroupsList_588712, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsLookup_589005 = ref object of OpenApiRestCall_588441
proc url_CloudidentityGroupsLookup_589007(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsLookup_589006(path: JsonNode; query: JsonNode;
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
  var valid_589008 = query.getOrDefault("upload_protocol")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "upload_protocol", valid_589008
  var valid_589009 = query.getOrDefault("fields")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "fields", valid_589009
  var valid_589010 = query.getOrDefault("quotaUser")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "quotaUser", valid_589010
  var valid_589011 = query.getOrDefault("alt")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = newJString("json"))
  if valid_589011 != nil:
    section.add "alt", valid_589011
  var valid_589012 = query.getOrDefault("oauth_token")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "oauth_token", valid_589012
  var valid_589013 = query.getOrDefault("callback")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "callback", valid_589013
  var valid_589014 = query.getOrDefault("access_token")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "access_token", valid_589014
  var valid_589015 = query.getOrDefault("uploadType")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "uploadType", valid_589015
  var valid_589016 = query.getOrDefault("groupKey.namespace")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "groupKey.namespace", valid_589016
  var valid_589017 = query.getOrDefault("key")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "key", valid_589017
  var valid_589018 = query.getOrDefault("$.xgafv")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = newJString("1"))
  if valid_589018 != nil:
    section.add "$.xgafv", valid_589018
  var valid_589019 = query.getOrDefault("prettyPrint")
  valid_589019 = validateParameter(valid_589019, JBool, required = false,
                                 default = newJBool(true))
  if valid_589019 != nil:
    section.add "prettyPrint", valid_589019
  var valid_589020 = query.getOrDefault("groupKey.id")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "groupKey.id", valid_589020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589021: Call_CloudidentityGroupsLookup_589005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Group by
  ## its EntityKey.
  ## 
  let valid = call_589021.validator(path, query, header, formData, body)
  let scheme = call_589021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589021.url(scheme.get, call_589021.host, call_589021.base,
                         call_589021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589021, url, valid)

proc call*(call_589022: Call_CloudidentityGroupsLookup_589005;
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
  var query_589023 = newJObject()
  add(query_589023, "upload_protocol", newJString(uploadProtocol))
  add(query_589023, "fields", newJString(fields))
  add(query_589023, "quotaUser", newJString(quotaUser))
  add(query_589023, "alt", newJString(alt))
  add(query_589023, "oauth_token", newJString(oauthToken))
  add(query_589023, "callback", newJString(callback))
  add(query_589023, "access_token", newJString(accessToken))
  add(query_589023, "uploadType", newJString(uploadType))
  add(query_589023, "groupKey.namespace", newJString(groupKeyNamespace))
  add(query_589023, "key", newJString(key))
  add(query_589023, "$.xgafv", newJString(Xgafv))
  add(query_589023, "prettyPrint", newJBool(prettyPrint))
  add(query_589023, "groupKey.id", newJString(groupKeyId))
  result = call_589022.call(nil, query_589023, nil, nil, nil)

var cloudidentityGroupsLookup* = Call_CloudidentityGroupsLookup_589005(
    name: "cloudidentityGroupsLookup", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1/groups:lookup",
    validator: validate_CloudidentityGroupsLookup_589006, base: "/",
    url: url_CloudidentityGroupsLookup_589007, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsSearch_589024 = ref object of OpenApiRestCall_588441
proc url_CloudidentityGroupsSearch_589026(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsSearch_589025(path: JsonNode; query: JsonNode;
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
  var valid_589027 = query.getOrDefault("upload_protocol")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "upload_protocol", valid_589027
  var valid_589028 = query.getOrDefault("fields")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "fields", valid_589028
  var valid_589029 = query.getOrDefault("pageToken")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "pageToken", valid_589029
  var valid_589030 = query.getOrDefault("quotaUser")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "quotaUser", valid_589030
  var valid_589031 = query.getOrDefault("view")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_589031 != nil:
    section.add "view", valid_589031
  var valid_589032 = query.getOrDefault("alt")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = newJString("json"))
  if valid_589032 != nil:
    section.add "alt", valid_589032
  var valid_589033 = query.getOrDefault("query")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "query", valid_589033
  var valid_589034 = query.getOrDefault("oauth_token")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "oauth_token", valid_589034
  var valid_589035 = query.getOrDefault("callback")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "callback", valid_589035
  var valid_589036 = query.getOrDefault("access_token")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "access_token", valid_589036
  var valid_589037 = query.getOrDefault("uploadType")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "uploadType", valid_589037
  var valid_589038 = query.getOrDefault("key")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "key", valid_589038
  var valid_589039 = query.getOrDefault("$.xgafv")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = newJString("1"))
  if valid_589039 != nil:
    section.add "$.xgafv", valid_589039
  var valid_589040 = query.getOrDefault("pageSize")
  valid_589040 = validateParameter(valid_589040, JInt, required = false, default = nil)
  if valid_589040 != nil:
    section.add "pageSize", valid_589040
  var valid_589041 = query.getOrDefault("prettyPrint")
  valid_589041 = validateParameter(valid_589041, JBool, required = false,
                                 default = newJBool(true))
  if valid_589041 != nil:
    section.add "prettyPrint", valid_589041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589042: Call_CloudidentityGroupsSearch_589024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for Groups.
  ## 
  let valid = call_589042.validator(path, query, header, formData, body)
  let scheme = call_589042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589042.url(scheme.get, call_589042.host, call_589042.base,
                         call_589042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589042, url, valid)

proc call*(call_589043: Call_CloudidentityGroupsSearch_589024;
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
  var query_589044 = newJObject()
  add(query_589044, "upload_protocol", newJString(uploadProtocol))
  add(query_589044, "fields", newJString(fields))
  add(query_589044, "pageToken", newJString(pageToken))
  add(query_589044, "quotaUser", newJString(quotaUser))
  add(query_589044, "view", newJString(view))
  add(query_589044, "alt", newJString(alt))
  add(query_589044, "query", newJString(query))
  add(query_589044, "oauth_token", newJString(oauthToken))
  add(query_589044, "callback", newJString(callback))
  add(query_589044, "access_token", newJString(accessToken))
  add(query_589044, "uploadType", newJString(uploadType))
  add(query_589044, "key", newJString(key))
  add(query_589044, "$.xgafv", newJString(Xgafv))
  add(query_589044, "pageSize", newJInt(pageSize))
  add(query_589044, "prettyPrint", newJBool(prettyPrint))
  result = call_589043.call(nil, query_589044, nil, nil, nil)

var cloudidentityGroupsSearch* = Call_CloudidentityGroupsSearch_589024(
    name: "cloudidentityGroupsSearch", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1/groups:search",
    validator: validate_CloudidentityGroupsSearch_589025, base: "/",
    url: url_CloudidentityGroupsSearch_589026, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsGet_589045 = ref object of OpenApiRestCall_588441
proc url_CloudidentityGroupsMembershipsGet_589047(protocol: Scheme; host: string;
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

proc validate_CloudidentityGroupsMembershipsGet_589046(path: JsonNode;
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
  var valid_589062 = path.getOrDefault("name")
  valid_589062 = validateParameter(valid_589062, JString, required = true,
                                 default = nil)
  if valid_589062 != nil:
    section.add "name", valid_589062
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
  var valid_589063 = query.getOrDefault("upload_protocol")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "upload_protocol", valid_589063
  var valid_589064 = query.getOrDefault("fields")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "fields", valid_589064
  var valid_589065 = query.getOrDefault("quotaUser")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "quotaUser", valid_589065
  var valid_589066 = query.getOrDefault("alt")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = newJString("json"))
  if valid_589066 != nil:
    section.add "alt", valid_589066
  var valid_589067 = query.getOrDefault("oauth_token")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "oauth_token", valid_589067
  var valid_589068 = query.getOrDefault("callback")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "callback", valid_589068
  var valid_589069 = query.getOrDefault("access_token")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "access_token", valid_589069
  var valid_589070 = query.getOrDefault("uploadType")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "uploadType", valid_589070
  var valid_589071 = query.getOrDefault("key")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "key", valid_589071
  var valid_589072 = query.getOrDefault("$.xgafv")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = newJString("1"))
  if valid_589072 != nil:
    section.add "$.xgafv", valid_589072
  var valid_589073 = query.getOrDefault("prettyPrint")
  valid_589073 = validateParameter(valid_589073, JBool, required = false,
                                 default = newJBool(true))
  if valid_589073 != nil:
    section.add "prettyPrint", valid_589073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589074: Call_CloudidentityGroupsMembershipsGet_589045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a Membership.
  ## 
  let valid = call_589074.validator(path, query, header, formData, body)
  let scheme = call_589074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589074.url(scheme.get, call_589074.host, call_589074.base,
                         call_589074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589074, url, valid)

proc call*(call_589075: Call_CloudidentityGroupsMembershipsGet_589045;
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
  var path_589076 = newJObject()
  var query_589077 = newJObject()
  add(query_589077, "upload_protocol", newJString(uploadProtocol))
  add(query_589077, "fields", newJString(fields))
  add(query_589077, "quotaUser", newJString(quotaUser))
  add(path_589076, "name", newJString(name))
  add(query_589077, "alt", newJString(alt))
  add(query_589077, "oauth_token", newJString(oauthToken))
  add(query_589077, "callback", newJString(callback))
  add(query_589077, "access_token", newJString(accessToken))
  add(query_589077, "uploadType", newJString(uploadType))
  add(query_589077, "key", newJString(key))
  add(query_589077, "$.xgafv", newJString(Xgafv))
  add(query_589077, "prettyPrint", newJBool(prettyPrint))
  result = call_589075.call(path_589076, query_589077, nil, nil, nil)

var cloudidentityGroupsMembershipsGet* = Call_CloudidentityGroupsMembershipsGet_589045(
    name: "cloudidentityGroupsMembershipsGet", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudidentityGroupsMembershipsGet_589046, base: "/",
    url: url_CloudidentityGroupsMembershipsGet_589047, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsPatch_589097 = ref object of OpenApiRestCall_588441
proc url_CloudidentityGroupsPatch_589099(protocol: Scheme; host: string;
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

proc validate_CloudidentityGroupsPatch_589098(path: JsonNode; query: JsonNode;
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
  var valid_589100 = path.getOrDefault("name")
  valid_589100 = validateParameter(valid_589100, JString, required = true,
                                 default = nil)
  if valid_589100 != nil:
    section.add "name", valid_589100
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
  var valid_589101 = query.getOrDefault("upload_protocol")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "upload_protocol", valid_589101
  var valid_589102 = query.getOrDefault("fields")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "fields", valid_589102
  var valid_589103 = query.getOrDefault("quotaUser")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "quotaUser", valid_589103
  var valid_589104 = query.getOrDefault("alt")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = newJString("json"))
  if valid_589104 != nil:
    section.add "alt", valid_589104
  var valid_589105 = query.getOrDefault("oauth_token")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "oauth_token", valid_589105
  var valid_589106 = query.getOrDefault("callback")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "callback", valid_589106
  var valid_589107 = query.getOrDefault("access_token")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "access_token", valid_589107
  var valid_589108 = query.getOrDefault("uploadType")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "uploadType", valid_589108
  var valid_589109 = query.getOrDefault("key")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "key", valid_589109
  var valid_589110 = query.getOrDefault("$.xgafv")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = newJString("1"))
  if valid_589110 != nil:
    section.add "$.xgafv", valid_589110
  var valid_589111 = query.getOrDefault("prettyPrint")
  valid_589111 = validateParameter(valid_589111, JBool, required = false,
                                 default = newJBool(true))
  if valid_589111 != nil:
    section.add "prettyPrint", valid_589111
  var valid_589112 = query.getOrDefault("updateMask")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "updateMask", valid_589112
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

proc call*(call_589114: Call_CloudidentityGroupsPatch_589097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Group.
  ## 
  let valid = call_589114.validator(path, query, header, formData, body)
  let scheme = call_589114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589114.url(scheme.get, call_589114.host, call_589114.base,
                         call_589114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589114, url, valid)

proc call*(call_589115: Call_CloudidentityGroupsPatch_589097; name: string;
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
  var path_589116 = newJObject()
  var query_589117 = newJObject()
  var body_589118 = newJObject()
  add(query_589117, "upload_protocol", newJString(uploadProtocol))
  add(query_589117, "fields", newJString(fields))
  add(query_589117, "quotaUser", newJString(quotaUser))
  add(path_589116, "name", newJString(name))
  add(query_589117, "alt", newJString(alt))
  add(query_589117, "oauth_token", newJString(oauthToken))
  add(query_589117, "callback", newJString(callback))
  add(query_589117, "access_token", newJString(accessToken))
  add(query_589117, "uploadType", newJString(uploadType))
  add(query_589117, "key", newJString(key))
  add(query_589117, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589118 = body
  add(query_589117, "prettyPrint", newJBool(prettyPrint))
  add(query_589117, "updateMask", newJString(updateMask))
  result = call_589115.call(path_589116, query_589117, nil, nil, body_589118)

var cloudidentityGroupsPatch* = Call_CloudidentityGroupsPatch_589097(
    name: "cloudidentityGroupsPatch", meth: HttpMethod.HttpPatch,
    host: "cloudidentity.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudidentityGroupsPatch_589098, base: "/",
    url: url_CloudidentityGroupsPatch_589099, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsDelete_589078 = ref object of OpenApiRestCall_588441
proc url_CloudidentityGroupsMembershipsDelete_589080(protocol: Scheme;
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

proc validate_CloudidentityGroupsMembershipsDelete_589079(path: JsonNode;
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
  var valid_589081 = path.getOrDefault("name")
  valid_589081 = validateParameter(valid_589081, JString, required = true,
                                 default = nil)
  if valid_589081 != nil:
    section.add "name", valid_589081
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
  var valid_589082 = query.getOrDefault("upload_protocol")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "upload_protocol", valid_589082
  var valid_589083 = query.getOrDefault("fields")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "fields", valid_589083
  var valid_589084 = query.getOrDefault("quotaUser")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "quotaUser", valid_589084
  var valid_589085 = query.getOrDefault("alt")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = newJString("json"))
  if valid_589085 != nil:
    section.add "alt", valid_589085
  var valid_589086 = query.getOrDefault("oauth_token")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "oauth_token", valid_589086
  var valid_589087 = query.getOrDefault("callback")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "callback", valid_589087
  var valid_589088 = query.getOrDefault("access_token")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "access_token", valid_589088
  var valid_589089 = query.getOrDefault("uploadType")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "uploadType", valid_589089
  var valid_589090 = query.getOrDefault("key")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "key", valid_589090
  var valid_589091 = query.getOrDefault("$.xgafv")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = newJString("1"))
  if valid_589091 != nil:
    section.add "$.xgafv", valid_589091
  var valid_589092 = query.getOrDefault("prettyPrint")
  valid_589092 = validateParameter(valid_589092, JBool, required = false,
                                 default = newJBool(true))
  if valid_589092 != nil:
    section.add "prettyPrint", valid_589092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589093: Call_CloudidentityGroupsMembershipsDelete_589078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a Membership.
  ## 
  let valid = call_589093.validator(path, query, header, formData, body)
  let scheme = call_589093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589093.url(scheme.get, call_589093.host, call_589093.base,
                         call_589093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589093, url, valid)

proc call*(call_589094: Call_CloudidentityGroupsMembershipsDelete_589078;
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
  var path_589095 = newJObject()
  var query_589096 = newJObject()
  add(query_589096, "upload_protocol", newJString(uploadProtocol))
  add(query_589096, "fields", newJString(fields))
  add(query_589096, "quotaUser", newJString(quotaUser))
  add(path_589095, "name", newJString(name))
  add(query_589096, "alt", newJString(alt))
  add(query_589096, "oauth_token", newJString(oauthToken))
  add(query_589096, "callback", newJString(callback))
  add(query_589096, "access_token", newJString(accessToken))
  add(query_589096, "uploadType", newJString(uploadType))
  add(query_589096, "key", newJString(key))
  add(query_589096, "$.xgafv", newJString(Xgafv))
  add(query_589096, "prettyPrint", newJBool(prettyPrint))
  result = call_589094.call(path_589095, query_589096, nil, nil, nil)

var cloudidentityGroupsMembershipsDelete* = Call_CloudidentityGroupsMembershipsDelete_589078(
    name: "cloudidentityGroupsMembershipsDelete", meth: HttpMethod.HttpDelete,
    host: "cloudidentity.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudidentityGroupsMembershipsDelete_589079, base: "/",
    url: url_CloudidentityGroupsMembershipsDelete_589080, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsCreate_589141 = ref object of OpenApiRestCall_588441
proc url_CloudidentityGroupsMembershipsCreate_589143(protocol: Scheme;
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

proc validate_CloudidentityGroupsMembershipsCreate_589142(path: JsonNode;
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
  var valid_589144 = path.getOrDefault("parent")
  valid_589144 = validateParameter(valid_589144, JString, required = true,
                                 default = nil)
  if valid_589144 != nil:
    section.add "parent", valid_589144
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
  var valid_589145 = query.getOrDefault("upload_protocol")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "upload_protocol", valid_589145
  var valid_589146 = query.getOrDefault("fields")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "fields", valid_589146
  var valid_589147 = query.getOrDefault("quotaUser")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "quotaUser", valid_589147
  var valid_589148 = query.getOrDefault("alt")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = newJString("json"))
  if valid_589148 != nil:
    section.add "alt", valid_589148
  var valid_589149 = query.getOrDefault("oauth_token")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "oauth_token", valid_589149
  var valid_589150 = query.getOrDefault("callback")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "callback", valid_589150
  var valid_589151 = query.getOrDefault("access_token")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "access_token", valid_589151
  var valid_589152 = query.getOrDefault("uploadType")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "uploadType", valid_589152
  var valid_589153 = query.getOrDefault("key")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "key", valid_589153
  var valid_589154 = query.getOrDefault("$.xgafv")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = newJString("1"))
  if valid_589154 != nil:
    section.add "$.xgafv", valid_589154
  var valid_589155 = query.getOrDefault("prettyPrint")
  valid_589155 = validateParameter(valid_589155, JBool, required = false,
                                 default = newJBool(true))
  if valid_589155 != nil:
    section.add "prettyPrint", valid_589155
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

proc call*(call_589157: Call_CloudidentityGroupsMembershipsCreate_589141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Membership.
  ## 
  let valid = call_589157.validator(path, query, header, formData, body)
  let scheme = call_589157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589157.url(scheme.get, call_589157.host, call_589157.base,
                         call_589157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589157, url, valid)

proc call*(call_589158: Call_CloudidentityGroupsMembershipsCreate_589141;
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
  var path_589159 = newJObject()
  var query_589160 = newJObject()
  var body_589161 = newJObject()
  add(query_589160, "upload_protocol", newJString(uploadProtocol))
  add(query_589160, "fields", newJString(fields))
  add(query_589160, "quotaUser", newJString(quotaUser))
  add(query_589160, "alt", newJString(alt))
  add(query_589160, "oauth_token", newJString(oauthToken))
  add(query_589160, "callback", newJString(callback))
  add(query_589160, "access_token", newJString(accessToken))
  add(query_589160, "uploadType", newJString(uploadType))
  add(path_589159, "parent", newJString(parent))
  add(query_589160, "key", newJString(key))
  add(query_589160, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589161 = body
  add(query_589160, "prettyPrint", newJBool(prettyPrint))
  result = call_589158.call(path_589159, query_589160, nil, nil, body_589161)

var cloudidentityGroupsMembershipsCreate* = Call_CloudidentityGroupsMembershipsCreate_589141(
    name: "cloudidentityGroupsMembershipsCreate", meth: HttpMethod.HttpPost,
    host: "cloudidentity.googleapis.com", route: "/v1/{parent}/memberships",
    validator: validate_CloudidentityGroupsMembershipsCreate_589142, base: "/",
    url: url_CloudidentityGroupsMembershipsCreate_589143, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsList_589119 = ref object of OpenApiRestCall_588441
proc url_CloudidentityGroupsMembershipsList_589121(protocol: Scheme; host: string;
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

proc validate_CloudidentityGroupsMembershipsList_589120(path: JsonNode;
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
  var valid_589122 = path.getOrDefault("parent")
  valid_589122 = validateParameter(valid_589122, JString, required = true,
                                 default = nil)
  if valid_589122 != nil:
    section.add "parent", valid_589122
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
  var valid_589123 = query.getOrDefault("upload_protocol")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "upload_protocol", valid_589123
  var valid_589124 = query.getOrDefault("fields")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "fields", valid_589124
  var valid_589125 = query.getOrDefault("pageToken")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "pageToken", valid_589125
  var valid_589126 = query.getOrDefault("quotaUser")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "quotaUser", valid_589126
  var valid_589127 = query.getOrDefault("view")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_589127 != nil:
    section.add "view", valid_589127
  var valid_589128 = query.getOrDefault("alt")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = newJString("json"))
  if valid_589128 != nil:
    section.add "alt", valid_589128
  var valid_589129 = query.getOrDefault("oauth_token")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "oauth_token", valid_589129
  var valid_589130 = query.getOrDefault("callback")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "callback", valid_589130
  var valid_589131 = query.getOrDefault("access_token")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "access_token", valid_589131
  var valid_589132 = query.getOrDefault("uploadType")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "uploadType", valid_589132
  var valid_589133 = query.getOrDefault("key")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "key", valid_589133
  var valid_589134 = query.getOrDefault("$.xgafv")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = newJString("1"))
  if valid_589134 != nil:
    section.add "$.xgafv", valid_589134
  var valid_589135 = query.getOrDefault("pageSize")
  valid_589135 = validateParameter(valid_589135, JInt, required = false, default = nil)
  if valid_589135 != nil:
    section.add "pageSize", valid_589135
  var valid_589136 = query.getOrDefault("prettyPrint")
  valid_589136 = validateParameter(valid_589136, JBool, required = false,
                                 default = newJBool(true))
  if valid_589136 != nil:
    section.add "prettyPrint", valid_589136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589137: Call_CloudidentityGroupsMembershipsList_589119;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Memberships within a Group.
  ## 
  let valid = call_589137.validator(path, query, header, formData, body)
  let scheme = call_589137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589137.url(scheme.get, call_589137.host, call_589137.base,
                         call_589137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589137, url, valid)

proc call*(call_589138: Call_CloudidentityGroupsMembershipsList_589119;
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
  var path_589139 = newJObject()
  var query_589140 = newJObject()
  add(query_589140, "upload_protocol", newJString(uploadProtocol))
  add(query_589140, "fields", newJString(fields))
  add(query_589140, "pageToken", newJString(pageToken))
  add(query_589140, "quotaUser", newJString(quotaUser))
  add(query_589140, "view", newJString(view))
  add(query_589140, "alt", newJString(alt))
  add(query_589140, "oauth_token", newJString(oauthToken))
  add(query_589140, "callback", newJString(callback))
  add(query_589140, "access_token", newJString(accessToken))
  add(query_589140, "uploadType", newJString(uploadType))
  add(path_589139, "parent", newJString(parent))
  add(query_589140, "key", newJString(key))
  add(query_589140, "$.xgafv", newJString(Xgafv))
  add(query_589140, "pageSize", newJInt(pageSize))
  add(query_589140, "prettyPrint", newJBool(prettyPrint))
  result = call_589138.call(path_589139, query_589140, nil, nil, nil)

var cloudidentityGroupsMembershipsList* = Call_CloudidentityGroupsMembershipsList_589119(
    name: "cloudidentityGroupsMembershipsList", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1/{parent}/memberships",
    validator: validate_CloudidentityGroupsMembershipsList_589120, base: "/",
    url: url_CloudidentityGroupsMembershipsList_589121, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsLookup_589162 = ref object of OpenApiRestCall_588441
proc url_CloudidentityGroupsMembershipsLookup_589164(protocol: Scheme;
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

proc validate_CloudidentityGroupsMembershipsLookup_589163(path: JsonNode;
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
  var valid_589165 = path.getOrDefault("parent")
  valid_589165 = validateParameter(valid_589165, JString, required = true,
                                 default = nil)
  if valid_589165 != nil:
    section.add "parent", valid_589165
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
  var valid_589170 = query.getOrDefault("oauth_token")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "oauth_token", valid_589170
  var valid_589171 = query.getOrDefault("callback")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "callback", valid_589171
  var valid_589172 = query.getOrDefault("access_token")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "access_token", valid_589172
  var valid_589173 = query.getOrDefault("uploadType")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "uploadType", valid_589173
  var valid_589174 = query.getOrDefault("memberKey.namespace")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "memberKey.namespace", valid_589174
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
  var valid_589177 = query.getOrDefault("memberKey.id")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "memberKey.id", valid_589177
  var valid_589178 = query.getOrDefault("prettyPrint")
  valid_589178 = validateParameter(valid_589178, JBool, required = false,
                                 default = newJBool(true))
  if valid_589178 != nil:
    section.add "prettyPrint", valid_589178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589179: Call_CloudidentityGroupsMembershipsLookup_589162;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Membership
  ## within a Group by member's EntityKey.
  ## 
  let valid = call_589179.validator(path, query, header, formData, body)
  let scheme = call_589179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589179.url(scheme.get, call_589179.host, call_589179.base,
                         call_589179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589179, url, valid)

proc call*(call_589180: Call_CloudidentityGroupsMembershipsLookup_589162;
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
  var path_589181 = newJObject()
  var query_589182 = newJObject()
  add(query_589182, "upload_protocol", newJString(uploadProtocol))
  add(query_589182, "fields", newJString(fields))
  add(query_589182, "quotaUser", newJString(quotaUser))
  add(query_589182, "alt", newJString(alt))
  add(query_589182, "oauth_token", newJString(oauthToken))
  add(query_589182, "callback", newJString(callback))
  add(query_589182, "access_token", newJString(accessToken))
  add(query_589182, "uploadType", newJString(uploadType))
  add(path_589181, "parent", newJString(parent))
  add(query_589182, "memberKey.namespace", newJString(memberKeyNamespace))
  add(query_589182, "key", newJString(key))
  add(query_589182, "$.xgafv", newJString(Xgafv))
  add(query_589182, "memberKey.id", newJString(memberKeyId))
  add(query_589182, "prettyPrint", newJBool(prettyPrint))
  result = call_589180.call(path_589181, query_589182, nil, nil, nil)

var cloudidentityGroupsMembershipsLookup* = Call_CloudidentityGroupsMembershipsLookup_589162(
    name: "cloudidentityGroupsMembershipsLookup", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com",
    route: "/v1/{parent}/memberships:lookup",
    validator: validate_CloudidentityGroupsMembershipsLookup_589163, base: "/",
    url: url_CloudidentityGroupsMembershipsLookup_589164, schemes: {Scheme.Https})
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
