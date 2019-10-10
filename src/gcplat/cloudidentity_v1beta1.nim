
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
  Call_CloudidentityGroupsCreate_588710 = ref object of OpenApiRestCall_588441
proc url_CloudidentityGroupsCreate_588712(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsCreate_588711(path: JsonNode; query: JsonNode;
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
  var valid_588826 = query.getOrDefault("quotaUser")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "quotaUser", valid_588826
  var valid_588840 = query.getOrDefault("alt")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = newJString("json"))
  if valid_588840 != nil:
    section.add "alt", valid_588840
  var valid_588841 = query.getOrDefault("oauth_token")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "oauth_token", valid_588841
  var valid_588842 = query.getOrDefault("callback")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "callback", valid_588842
  var valid_588843 = query.getOrDefault("access_token")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "access_token", valid_588843
  var valid_588844 = query.getOrDefault("uploadType")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "uploadType", valid_588844
  var valid_588845 = query.getOrDefault("key")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "key", valid_588845
  var valid_588846 = query.getOrDefault("$.xgafv")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = newJString("1"))
  if valid_588846 != nil:
    section.add "$.xgafv", valid_588846
  var valid_588847 = query.getOrDefault("prettyPrint")
  valid_588847 = validateParameter(valid_588847, JBool, required = false,
                                 default = newJBool(true))
  if valid_588847 != nil:
    section.add "prettyPrint", valid_588847
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

proc call*(call_588871: Call_CloudidentityGroupsCreate_588710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Group.
  ## 
  let valid = call_588871.validator(path, query, header, formData, body)
  let scheme = call_588871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588871.url(scheme.get, call_588871.host, call_588871.base,
                         call_588871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588871, url, valid)

proc call*(call_588942: Call_CloudidentityGroupsCreate_588710;
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
  var query_588943 = newJObject()
  var body_588945 = newJObject()
  add(query_588943, "upload_protocol", newJString(uploadProtocol))
  add(query_588943, "fields", newJString(fields))
  add(query_588943, "quotaUser", newJString(quotaUser))
  add(query_588943, "alt", newJString(alt))
  add(query_588943, "oauth_token", newJString(oauthToken))
  add(query_588943, "callback", newJString(callback))
  add(query_588943, "access_token", newJString(accessToken))
  add(query_588943, "uploadType", newJString(uploadType))
  add(query_588943, "key", newJString(key))
  add(query_588943, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_588945 = body
  add(query_588943, "prettyPrint", newJBool(prettyPrint))
  result = call_588942.call(nil, query_588943, nil, nil, body_588945)

var cloudidentityGroupsCreate* = Call_CloudidentityGroupsCreate_588710(
    name: "cloudidentityGroupsCreate", meth: HttpMethod.HttpPost,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/groups",
    validator: validate_CloudidentityGroupsCreate_588711, base: "/",
    url: url_CloudidentityGroupsCreate_588712, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsLookup_588984 = ref object of OpenApiRestCall_588441
proc url_CloudidentityGroupsLookup_588986(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsLookup_588985(path: JsonNode; query: JsonNode;
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
  var valid_588987 = query.getOrDefault("upload_protocol")
  valid_588987 = validateParameter(valid_588987, JString, required = false,
                                 default = nil)
  if valid_588987 != nil:
    section.add "upload_protocol", valid_588987
  var valid_588988 = query.getOrDefault("fields")
  valid_588988 = validateParameter(valid_588988, JString, required = false,
                                 default = nil)
  if valid_588988 != nil:
    section.add "fields", valid_588988
  var valid_588989 = query.getOrDefault("quotaUser")
  valid_588989 = validateParameter(valid_588989, JString, required = false,
                                 default = nil)
  if valid_588989 != nil:
    section.add "quotaUser", valid_588989
  var valid_588990 = query.getOrDefault("alt")
  valid_588990 = validateParameter(valid_588990, JString, required = false,
                                 default = newJString("json"))
  if valid_588990 != nil:
    section.add "alt", valid_588990
  var valid_588991 = query.getOrDefault("oauth_token")
  valid_588991 = validateParameter(valid_588991, JString, required = false,
                                 default = nil)
  if valid_588991 != nil:
    section.add "oauth_token", valid_588991
  var valid_588992 = query.getOrDefault("callback")
  valid_588992 = validateParameter(valid_588992, JString, required = false,
                                 default = nil)
  if valid_588992 != nil:
    section.add "callback", valid_588992
  var valid_588993 = query.getOrDefault("access_token")
  valid_588993 = validateParameter(valid_588993, JString, required = false,
                                 default = nil)
  if valid_588993 != nil:
    section.add "access_token", valid_588993
  var valid_588994 = query.getOrDefault("uploadType")
  valid_588994 = validateParameter(valid_588994, JString, required = false,
                                 default = nil)
  if valid_588994 != nil:
    section.add "uploadType", valid_588994
  var valid_588995 = query.getOrDefault("groupKey.namespace")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = nil)
  if valid_588995 != nil:
    section.add "groupKey.namespace", valid_588995
  var valid_588996 = query.getOrDefault("key")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "key", valid_588996
  var valid_588997 = query.getOrDefault("$.xgafv")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = newJString("1"))
  if valid_588997 != nil:
    section.add "$.xgafv", valid_588997
  var valid_588998 = query.getOrDefault("prettyPrint")
  valid_588998 = validateParameter(valid_588998, JBool, required = false,
                                 default = newJBool(true))
  if valid_588998 != nil:
    section.add "prettyPrint", valid_588998
  var valid_588999 = query.getOrDefault("groupKey.id")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "groupKey.id", valid_588999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589000: Call_CloudidentityGroupsLookup_588984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Group by
  ## its EntityKey.
  ## 
  let valid = call_589000.validator(path, query, header, formData, body)
  let scheme = call_589000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589000.url(scheme.get, call_589000.host, call_589000.base,
                         call_589000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589000, url, valid)

proc call*(call_589001: Call_CloudidentityGroupsLookup_588984;
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
  var query_589002 = newJObject()
  add(query_589002, "upload_protocol", newJString(uploadProtocol))
  add(query_589002, "fields", newJString(fields))
  add(query_589002, "quotaUser", newJString(quotaUser))
  add(query_589002, "alt", newJString(alt))
  add(query_589002, "oauth_token", newJString(oauthToken))
  add(query_589002, "callback", newJString(callback))
  add(query_589002, "access_token", newJString(accessToken))
  add(query_589002, "uploadType", newJString(uploadType))
  add(query_589002, "groupKey.namespace", newJString(groupKeyNamespace))
  add(query_589002, "key", newJString(key))
  add(query_589002, "$.xgafv", newJString(Xgafv))
  add(query_589002, "prettyPrint", newJBool(prettyPrint))
  add(query_589002, "groupKey.id", newJString(groupKeyId))
  result = call_589001.call(nil, query_589002, nil, nil, nil)

var cloudidentityGroupsLookup* = Call_CloudidentityGroupsLookup_588984(
    name: "cloudidentityGroupsLookup", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/groups:lookup",
    validator: validate_CloudidentityGroupsLookup_588985, base: "/",
    url: url_CloudidentityGroupsLookup_588986, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsSearch_589003 = ref object of OpenApiRestCall_588441
proc url_CloudidentityGroupsSearch_589005(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudidentityGroupsSearch_589004(path: JsonNode; query: JsonNode;
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
  var valid_589006 = query.getOrDefault("upload_protocol")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "upload_protocol", valid_589006
  var valid_589007 = query.getOrDefault("fields")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "fields", valid_589007
  var valid_589008 = query.getOrDefault("pageToken")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "pageToken", valid_589008
  var valid_589009 = query.getOrDefault("quotaUser")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "quotaUser", valid_589009
  var valid_589010 = query.getOrDefault("view")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589010 != nil:
    section.add "view", valid_589010
  var valid_589011 = query.getOrDefault("alt")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = newJString("json"))
  if valid_589011 != nil:
    section.add "alt", valid_589011
  var valid_589012 = query.getOrDefault("query")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "query", valid_589012
  var valid_589013 = query.getOrDefault("oauth_token")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "oauth_token", valid_589013
  var valid_589014 = query.getOrDefault("callback")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "callback", valid_589014
  var valid_589015 = query.getOrDefault("access_token")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "access_token", valid_589015
  var valid_589016 = query.getOrDefault("uploadType")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "uploadType", valid_589016
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
  var valid_589019 = query.getOrDefault("pageSize")
  valid_589019 = validateParameter(valid_589019, JInt, required = false, default = nil)
  if valid_589019 != nil:
    section.add "pageSize", valid_589019
  var valid_589020 = query.getOrDefault("prettyPrint")
  valid_589020 = validateParameter(valid_589020, JBool, required = false,
                                 default = newJBool(true))
  if valid_589020 != nil:
    section.add "prettyPrint", valid_589020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589021: Call_CloudidentityGroupsSearch_589003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for Groups.
  ## 
  let valid = call_589021.validator(path, query, header, formData, body)
  let scheme = call_589021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589021.url(scheme.get, call_589021.host, call_589021.base,
                         call_589021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589021, url, valid)

proc call*(call_589022: Call_CloudidentityGroupsSearch_589003;
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
  var query_589023 = newJObject()
  add(query_589023, "upload_protocol", newJString(uploadProtocol))
  add(query_589023, "fields", newJString(fields))
  add(query_589023, "pageToken", newJString(pageToken))
  add(query_589023, "quotaUser", newJString(quotaUser))
  add(query_589023, "view", newJString(view))
  add(query_589023, "alt", newJString(alt))
  add(query_589023, "query", newJString(query))
  add(query_589023, "oauth_token", newJString(oauthToken))
  add(query_589023, "callback", newJString(callback))
  add(query_589023, "access_token", newJString(accessToken))
  add(query_589023, "uploadType", newJString(uploadType))
  add(query_589023, "key", newJString(key))
  add(query_589023, "$.xgafv", newJString(Xgafv))
  add(query_589023, "pageSize", newJInt(pageSize))
  add(query_589023, "prettyPrint", newJBool(prettyPrint))
  result = call_589022.call(nil, query_589023, nil, nil, nil)

var cloudidentityGroupsSearch* = Call_CloudidentityGroupsSearch_589003(
    name: "cloudidentityGroupsSearch", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/groups:search",
    validator: validate_CloudidentityGroupsSearch_589004, base: "/",
    url: url_CloudidentityGroupsSearch_589005, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsGet_589024 = ref object of OpenApiRestCall_588441
proc url_CloudidentityGroupsMembershipsGet_589026(protocol: Scheme; host: string;
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

proc validate_CloudidentityGroupsMembershipsGet_589025(path: JsonNode;
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
  var valid_589041 = path.getOrDefault("name")
  valid_589041 = validateParameter(valid_589041, JString, required = true,
                                 default = nil)
  if valid_589041 != nil:
    section.add "name", valid_589041
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
  var valid_589042 = query.getOrDefault("upload_protocol")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "upload_protocol", valid_589042
  var valid_589043 = query.getOrDefault("fields")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "fields", valid_589043
  var valid_589044 = query.getOrDefault("quotaUser")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "quotaUser", valid_589044
  var valid_589045 = query.getOrDefault("alt")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = newJString("json"))
  if valid_589045 != nil:
    section.add "alt", valid_589045
  var valid_589046 = query.getOrDefault("oauth_token")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "oauth_token", valid_589046
  var valid_589047 = query.getOrDefault("callback")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "callback", valid_589047
  var valid_589048 = query.getOrDefault("access_token")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "access_token", valid_589048
  var valid_589049 = query.getOrDefault("uploadType")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "uploadType", valid_589049
  var valid_589050 = query.getOrDefault("key")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "key", valid_589050
  var valid_589051 = query.getOrDefault("$.xgafv")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = newJString("1"))
  if valid_589051 != nil:
    section.add "$.xgafv", valid_589051
  var valid_589052 = query.getOrDefault("prettyPrint")
  valid_589052 = validateParameter(valid_589052, JBool, required = false,
                                 default = newJBool(true))
  if valid_589052 != nil:
    section.add "prettyPrint", valid_589052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589053: Call_CloudidentityGroupsMembershipsGet_589024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a Membership.
  ## 
  let valid = call_589053.validator(path, query, header, formData, body)
  let scheme = call_589053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589053.url(scheme.get, call_589053.host, call_589053.base,
                         call_589053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589053, url, valid)

proc call*(call_589054: Call_CloudidentityGroupsMembershipsGet_589024;
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
  var path_589055 = newJObject()
  var query_589056 = newJObject()
  add(query_589056, "upload_protocol", newJString(uploadProtocol))
  add(query_589056, "fields", newJString(fields))
  add(query_589056, "quotaUser", newJString(quotaUser))
  add(path_589055, "name", newJString(name))
  add(query_589056, "alt", newJString(alt))
  add(query_589056, "oauth_token", newJString(oauthToken))
  add(query_589056, "callback", newJString(callback))
  add(query_589056, "access_token", newJString(accessToken))
  add(query_589056, "uploadType", newJString(uploadType))
  add(query_589056, "key", newJString(key))
  add(query_589056, "$.xgafv", newJString(Xgafv))
  add(query_589056, "prettyPrint", newJBool(prettyPrint))
  result = call_589054.call(path_589055, query_589056, nil, nil, nil)

var cloudidentityGroupsMembershipsGet* = Call_CloudidentityGroupsMembershipsGet_589024(
    name: "cloudidentityGroupsMembershipsGet", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudidentityGroupsMembershipsGet_589025, base: "/",
    url: url_CloudidentityGroupsMembershipsGet_589026, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsPatch_589076 = ref object of OpenApiRestCall_588441
proc url_CloudidentityGroupsPatch_589078(protocol: Scheme; host: string;
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

proc validate_CloudidentityGroupsPatch_589077(path: JsonNode; query: JsonNode;
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
  var valid_589079 = path.getOrDefault("name")
  valid_589079 = validateParameter(valid_589079, JString, required = true,
                                 default = nil)
  if valid_589079 != nil:
    section.add "name", valid_589079
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
  var valid_589080 = query.getOrDefault("upload_protocol")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "upload_protocol", valid_589080
  var valid_589081 = query.getOrDefault("fields")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "fields", valid_589081
  var valid_589082 = query.getOrDefault("quotaUser")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "quotaUser", valid_589082
  var valid_589083 = query.getOrDefault("alt")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = newJString("json"))
  if valid_589083 != nil:
    section.add "alt", valid_589083
  var valid_589084 = query.getOrDefault("oauth_token")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "oauth_token", valid_589084
  var valid_589085 = query.getOrDefault("callback")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "callback", valid_589085
  var valid_589086 = query.getOrDefault("access_token")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "access_token", valid_589086
  var valid_589087 = query.getOrDefault("uploadType")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "uploadType", valid_589087
  var valid_589088 = query.getOrDefault("key")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "key", valid_589088
  var valid_589089 = query.getOrDefault("$.xgafv")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = newJString("1"))
  if valid_589089 != nil:
    section.add "$.xgafv", valid_589089
  var valid_589090 = query.getOrDefault("prettyPrint")
  valid_589090 = validateParameter(valid_589090, JBool, required = false,
                                 default = newJBool(true))
  if valid_589090 != nil:
    section.add "prettyPrint", valid_589090
  var valid_589091 = query.getOrDefault("updateMask")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "updateMask", valid_589091
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

proc call*(call_589093: Call_CloudidentityGroupsPatch_589076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Group.
  ## 
  let valid = call_589093.validator(path, query, header, formData, body)
  let scheme = call_589093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589093.url(scheme.get, call_589093.host, call_589093.base,
                         call_589093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589093, url, valid)

proc call*(call_589094: Call_CloudidentityGroupsPatch_589076; name: string;
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
  var path_589095 = newJObject()
  var query_589096 = newJObject()
  var body_589097 = newJObject()
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
  if body != nil:
    body_589097 = body
  add(query_589096, "prettyPrint", newJBool(prettyPrint))
  add(query_589096, "updateMask", newJString(updateMask))
  result = call_589094.call(path_589095, query_589096, nil, nil, body_589097)

var cloudidentityGroupsPatch* = Call_CloudidentityGroupsPatch_589076(
    name: "cloudidentityGroupsPatch", meth: HttpMethod.HttpPatch,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudidentityGroupsPatch_589077, base: "/",
    url: url_CloudidentityGroupsPatch_589078, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsDelete_589057 = ref object of OpenApiRestCall_588441
proc url_CloudidentityGroupsMembershipsDelete_589059(protocol: Scheme;
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

proc validate_CloudidentityGroupsMembershipsDelete_589058(path: JsonNode;
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
  var valid_589060 = path.getOrDefault("name")
  valid_589060 = validateParameter(valid_589060, JString, required = true,
                                 default = nil)
  if valid_589060 != nil:
    section.add "name", valid_589060
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
  var valid_589061 = query.getOrDefault("upload_protocol")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "upload_protocol", valid_589061
  var valid_589062 = query.getOrDefault("fields")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "fields", valid_589062
  var valid_589063 = query.getOrDefault("quotaUser")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "quotaUser", valid_589063
  var valid_589064 = query.getOrDefault("alt")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = newJString("json"))
  if valid_589064 != nil:
    section.add "alt", valid_589064
  var valid_589065 = query.getOrDefault("oauth_token")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "oauth_token", valid_589065
  var valid_589066 = query.getOrDefault("callback")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "callback", valid_589066
  var valid_589067 = query.getOrDefault("access_token")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "access_token", valid_589067
  var valid_589068 = query.getOrDefault("uploadType")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "uploadType", valid_589068
  var valid_589069 = query.getOrDefault("key")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "key", valid_589069
  var valid_589070 = query.getOrDefault("$.xgafv")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = newJString("1"))
  if valid_589070 != nil:
    section.add "$.xgafv", valid_589070
  var valid_589071 = query.getOrDefault("prettyPrint")
  valid_589071 = validateParameter(valid_589071, JBool, required = false,
                                 default = newJBool(true))
  if valid_589071 != nil:
    section.add "prettyPrint", valid_589071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589072: Call_CloudidentityGroupsMembershipsDelete_589057;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a Membership.
  ## 
  let valid = call_589072.validator(path, query, header, formData, body)
  let scheme = call_589072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589072.url(scheme.get, call_589072.host, call_589072.base,
                         call_589072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589072, url, valid)

proc call*(call_589073: Call_CloudidentityGroupsMembershipsDelete_589057;
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
  var path_589074 = newJObject()
  var query_589075 = newJObject()
  add(query_589075, "upload_protocol", newJString(uploadProtocol))
  add(query_589075, "fields", newJString(fields))
  add(query_589075, "quotaUser", newJString(quotaUser))
  add(path_589074, "name", newJString(name))
  add(query_589075, "alt", newJString(alt))
  add(query_589075, "oauth_token", newJString(oauthToken))
  add(query_589075, "callback", newJString(callback))
  add(query_589075, "access_token", newJString(accessToken))
  add(query_589075, "uploadType", newJString(uploadType))
  add(query_589075, "key", newJString(key))
  add(query_589075, "$.xgafv", newJString(Xgafv))
  add(query_589075, "prettyPrint", newJBool(prettyPrint))
  result = call_589073.call(path_589074, query_589075, nil, nil, nil)

var cloudidentityGroupsMembershipsDelete* = Call_CloudidentityGroupsMembershipsDelete_589057(
    name: "cloudidentityGroupsMembershipsDelete", meth: HttpMethod.HttpDelete,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudidentityGroupsMembershipsDelete_589058, base: "/",
    url: url_CloudidentityGroupsMembershipsDelete_589059, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsCreate_589120 = ref object of OpenApiRestCall_588441
proc url_CloudidentityGroupsMembershipsCreate_589122(protocol: Scheme;
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

proc validate_CloudidentityGroupsMembershipsCreate_589121(path: JsonNode;
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
  var valid_589123 = path.getOrDefault("parent")
  valid_589123 = validateParameter(valid_589123, JString, required = true,
                                 default = nil)
  if valid_589123 != nil:
    section.add "parent", valid_589123
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
  var valid_589124 = query.getOrDefault("upload_protocol")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "upload_protocol", valid_589124
  var valid_589125 = query.getOrDefault("fields")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "fields", valid_589125
  var valid_589126 = query.getOrDefault("quotaUser")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "quotaUser", valid_589126
  var valid_589127 = query.getOrDefault("alt")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = newJString("json"))
  if valid_589127 != nil:
    section.add "alt", valid_589127
  var valid_589128 = query.getOrDefault("oauth_token")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "oauth_token", valid_589128
  var valid_589129 = query.getOrDefault("callback")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "callback", valid_589129
  var valid_589130 = query.getOrDefault("access_token")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "access_token", valid_589130
  var valid_589131 = query.getOrDefault("uploadType")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "uploadType", valid_589131
  var valid_589132 = query.getOrDefault("key")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "key", valid_589132
  var valid_589133 = query.getOrDefault("$.xgafv")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = newJString("1"))
  if valid_589133 != nil:
    section.add "$.xgafv", valid_589133
  var valid_589134 = query.getOrDefault("prettyPrint")
  valid_589134 = validateParameter(valid_589134, JBool, required = false,
                                 default = newJBool(true))
  if valid_589134 != nil:
    section.add "prettyPrint", valid_589134
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

proc call*(call_589136: Call_CloudidentityGroupsMembershipsCreate_589120;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Membership.
  ## 
  let valid = call_589136.validator(path, query, header, formData, body)
  let scheme = call_589136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589136.url(scheme.get, call_589136.host, call_589136.base,
                         call_589136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589136, url, valid)

proc call*(call_589137: Call_CloudidentityGroupsMembershipsCreate_589120;
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
  var path_589138 = newJObject()
  var query_589139 = newJObject()
  var body_589140 = newJObject()
  add(query_589139, "upload_protocol", newJString(uploadProtocol))
  add(query_589139, "fields", newJString(fields))
  add(query_589139, "quotaUser", newJString(quotaUser))
  add(query_589139, "alt", newJString(alt))
  add(query_589139, "oauth_token", newJString(oauthToken))
  add(query_589139, "callback", newJString(callback))
  add(query_589139, "access_token", newJString(accessToken))
  add(query_589139, "uploadType", newJString(uploadType))
  add(path_589138, "parent", newJString(parent))
  add(query_589139, "key", newJString(key))
  add(query_589139, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589140 = body
  add(query_589139, "prettyPrint", newJBool(prettyPrint))
  result = call_589137.call(path_589138, query_589139, nil, nil, body_589140)

var cloudidentityGroupsMembershipsCreate* = Call_CloudidentityGroupsMembershipsCreate_589120(
    name: "cloudidentityGroupsMembershipsCreate", meth: HttpMethod.HttpPost,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/{parent}/memberships",
    validator: validate_CloudidentityGroupsMembershipsCreate_589121, base: "/",
    url: url_CloudidentityGroupsMembershipsCreate_589122, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsList_589098 = ref object of OpenApiRestCall_588441
proc url_CloudidentityGroupsMembershipsList_589100(protocol: Scheme; host: string;
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

proc validate_CloudidentityGroupsMembershipsList_589099(path: JsonNode;
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
  var valid_589101 = path.getOrDefault("parent")
  valid_589101 = validateParameter(valid_589101, JString, required = true,
                                 default = nil)
  if valid_589101 != nil:
    section.add "parent", valid_589101
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
  var valid_589102 = query.getOrDefault("upload_protocol")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "upload_protocol", valid_589102
  var valid_589103 = query.getOrDefault("fields")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "fields", valid_589103
  var valid_589104 = query.getOrDefault("pageToken")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "pageToken", valid_589104
  var valid_589105 = query.getOrDefault("quotaUser")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "quotaUser", valid_589105
  var valid_589106 = query.getOrDefault("view")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589106 != nil:
    section.add "view", valid_589106
  var valid_589107 = query.getOrDefault("alt")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = newJString("json"))
  if valid_589107 != nil:
    section.add "alt", valid_589107
  var valid_589108 = query.getOrDefault("oauth_token")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "oauth_token", valid_589108
  var valid_589109 = query.getOrDefault("callback")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "callback", valid_589109
  var valid_589110 = query.getOrDefault("access_token")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "access_token", valid_589110
  var valid_589111 = query.getOrDefault("uploadType")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "uploadType", valid_589111
  var valid_589112 = query.getOrDefault("key")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "key", valid_589112
  var valid_589113 = query.getOrDefault("$.xgafv")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = newJString("1"))
  if valid_589113 != nil:
    section.add "$.xgafv", valid_589113
  var valid_589114 = query.getOrDefault("pageSize")
  valid_589114 = validateParameter(valid_589114, JInt, required = false, default = nil)
  if valid_589114 != nil:
    section.add "pageSize", valid_589114
  var valid_589115 = query.getOrDefault("prettyPrint")
  valid_589115 = validateParameter(valid_589115, JBool, required = false,
                                 default = newJBool(true))
  if valid_589115 != nil:
    section.add "prettyPrint", valid_589115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589116: Call_CloudidentityGroupsMembershipsList_589098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Memberships within a Group.
  ## 
  let valid = call_589116.validator(path, query, header, formData, body)
  let scheme = call_589116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589116.url(scheme.get, call_589116.host, call_589116.base,
                         call_589116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589116, url, valid)

proc call*(call_589117: Call_CloudidentityGroupsMembershipsList_589098;
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
  var path_589118 = newJObject()
  var query_589119 = newJObject()
  add(query_589119, "upload_protocol", newJString(uploadProtocol))
  add(query_589119, "fields", newJString(fields))
  add(query_589119, "pageToken", newJString(pageToken))
  add(query_589119, "quotaUser", newJString(quotaUser))
  add(query_589119, "view", newJString(view))
  add(query_589119, "alt", newJString(alt))
  add(query_589119, "oauth_token", newJString(oauthToken))
  add(query_589119, "callback", newJString(callback))
  add(query_589119, "access_token", newJString(accessToken))
  add(query_589119, "uploadType", newJString(uploadType))
  add(path_589118, "parent", newJString(parent))
  add(query_589119, "key", newJString(key))
  add(query_589119, "$.xgafv", newJString(Xgafv))
  add(query_589119, "pageSize", newJInt(pageSize))
  add(query_589119, "prettyPrint", newJBool(prettyPrint))
  result = call_589117.call(path_589118, query_589119, nil, nil, nil)

var cloudidentityGroupsMembershipsList* = Call_CloudidentityGroupsMembershipsList_589098(
    name: "cloudidentityGroupsMembershipsList", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com", route: "/v1beta1/{parent}/memberships",
    validator: validate_CloudidentityGroupsMembershipsList_589099, base: "/",
    url: url_CloudidentityGroupsMembershipsList_589100, schemes: {Scheme.Https})
type
  Call_CloudidentityGroupsMembershipsLookup_589141 = ref object of OpenApiRestCall_588441
proc url_CloudidentityGroupsMembershipsLookup_589143(protocol: Scheme;
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

proc validate_CloudidentityGroupsMembershipsLookup_589142(path: JsonNode;
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
  var valid_589153 = query.getOrDefault("memberKey.namespace")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "memberKey.namespace", valid_589153
  var valid_589154 = query.getOrDefault("key")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "key", valid_589154
  var valid_589155 = query.getOrDefault("$.xgafv")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = newJString("1"))
  if valid_589155 != nil:
    section.add "$.xgafv", valid_589155
  var valid_589156 = query.getOrDefault("memberKey.id")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "memberKey.id", valid_589156
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
  if body != nil:
    result.add "body", body

proc call*(call_589158: Call_CloudidentityGroupsMembershipsLookup_589141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up [resource
  ## name](https://cloud.google.com/apis/design/resource_names) of a Membership
  ## within a Group by member's EntityKey.
  ## 
  let valid = call_589158.validator(path, query, header, formData, body)
  let scheme = call_589158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589158.url(scheme.get, call_589158.host, call_589158.base,
                         call_589158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589158, url, valid)

proc call*(call_589159: Call_CloudidentityGroupsMembershipsLookup_589141;
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
  var path_589160 = newJObject()
  var query_589161 = newJObject()
  add(query_589161, "upload_protocol", newJString(uploadProtocol))
  add(query_589161, "fields", newJString(fields))
  add(query_589161, "quotaUser", newJString(quotaUser))
  add(query_589161, "alt", newJString(alt))
  add(query_589161, "oauth_token", newJString(oauthToken))
  add(query_589161, "callback", newJString(callback))
  add(query_589161, "access_token", newJString(accessToken))
  add(query_589161, "uploadType", newJString(uploadType))
  add(path_589160, "parent", newJString(parent))
  add(query_589161, "memberKey.namespace", newJString(memberKeyNamespace))
  add(query_589161, "key", newJString(key))
  add(query_589161, "$.xgafv", newJString(Xgafv))
  add(query_589161, "memberKey.id", newJString(memberKeyId))
  add(query_589161, "prettyPrint", newJBool(prettyPrint))
  result = call_589159.call(path_589160, query_589161, nil, nil, nil)

var cloudidentityGroupsMembershipsLookup* = Call_CloudidentityGroupsMembershipsLookup_589141(
    name: "cloudidentityGroupsMembershipsLookup", meth: HttpMethod.HttpGet,
    host: "cloudidentity.googleapis.com",
    route: "/v1beta1/{parent}/memberships:lookup",
    validator: validate_CloudidentityGroupsMembershipsLookup_589142, base: "/",
    url: url_CloudidentityGroupsMembershipsLookup_589143, schemes: {Scheme.Https})
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
