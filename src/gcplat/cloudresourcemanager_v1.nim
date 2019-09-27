
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud Resource Manager
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Creates, reads, and updates metadata for Google Cloud Platform resource containers.
## 
## https://cloud.google.com/resource-manager
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

  OpenApiRestCall_597421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597421): Option[Scheme] {.used.} =
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
  gcpServiceName = "cloudresourcemanager"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudresourcemanagerLiensCreate_597965 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerLiensCreate_597967(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerLiensCreate_597966(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a Lien which applies to the resource denoted by the `parent` field.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, applying to `projects/1234` requires permission
  ## `resourcemanager.projects.updateLiens`.
  ## 
  ## NOTE: Some resources may limit the number of Liens which may be applied.
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
  var valid_597968 = query.getOrDefault("upload_protocol")
  valid_597968 = validateParameter(valid_597968, JString, required = false,
                                 default = nil)
  if valid_597968 != nil:
    section.add "upload_protocol", valid_597968
  var valid_597969 = query.getOrDefault("fields")
  valid_597969 = validateParameter(valid_597969, JString, required = false,
                                 default = nil)
  if valid_597969 != nil:
    section.add "fields", valid_597969
  var valid_597970 = query.getOrDefault("quotaUser")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "quotaUser", valid_597970
  var valid_597971 = query.getOrDefault("alt")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = newJString("json"))
  if valid_597971 != nil:
    section.add "alt", valid_597971
  var valid_597972 = query.getOrDefault("oauth_token")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = nil)
  if valid_597972 != nil:
    section.add "oauth_token", valid_597972
  var valid_597973 = query.getOrDefault("callback")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "callback", valid_597973
  var valid_597974 = query.getOrDefault("access_token")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "access_token", valid_597974
  var valid_597975 = query.getOrDefault("uploadType")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "uploadType", valid_597975
  var valid_597976 = query.getOrDefault("key")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "key", valid_597976
  var valid_597977 = query.getOrDefault("$.xgafv")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = newJString("1"))
  if valid_597977 != nil:
    section.add "$.xgafv", valid_597977
  var valid_597978 = query.getOrDefault("prettyPrint")
  valid_597978 = validateParameter(valid_597978, JBool, required = false,
                                 default = newJBool(true))
  if valid_597978 != nil:
    section.add "prettyPrint", valid_597978
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

proc call*(call_597980: Call_CloudresourcemanagerLiensCreate_597965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a Lien which applies to the resource denoted by the `parent` field.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, applying to `projects/1234` requires permission
  ## `resourcemanager.projects.updateLiens`.
  ## 
  ## NOTE: Some resources may limit the number of Liens which may be applied.
  ## 
  let valid = call_597980.validator(path, query, header, formData, body)
  let scheme = call_597980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597980.url(scheme.get, call_597980.host, call_597980.base,
                         call_597980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597980, url, valid)

proc call*(call_597981: Call_CloudresourcemanagerLiensCreate_597965;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerLiensCreate
  ## Create a Lien which applies to the resource denoted by the `parent` field.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, applying to `projects/1234` requires permission
  ## `resourcemanager.projects.updateLiens`.
  ## 
  ## NOTE: Some resources may limit the number of Liens which may be applied.
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
  var query_597982 = newJObject()
  var body_597983 = newJObject()
  add(query_597982, "upload_protocol", newJString(uploadProtocol))
  add(query_597982, "fields", newJString(fields))
  add(query_597982, "quotaUser", newJString(quotaUser))
  add(query_597982, "alt", newJString(alt))
  add(query_597982, "oauth_token", newJString(oauthToken))
  add(query_597982, "callback", newJString(callback))
  add(query_597982, "access_token", newJString(accessToken))
  add(query_597982, "uploadType", newJString(uploadType))
  add(query_597982, "key", newJString(key))
  add(query_597982, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597983 = body
  add(query_597982, "prettyPrint", newJBool(prettyPrint))
  result = call_597981.call(nil, query_597982, nil, nil, body_597983)

var cloudresourcemanagerLiensCreate* = Call_CloudresourcemanagerLiensCreate_597965(
    name: "cloudresourcemanagerLiensCreate", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/liens",
    validator: validate_CloudresourcemanagerLiensCreate_597966, base: "/",
    url: url_CloudresourcemanagerLiensCreate_597967, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerLiensList_597690 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerLiensList_597692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerLiensList_597691(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all Liens applied to the `parent` resource.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, a Lien with a `parent` of `projects/1234` requires permission
  ## `resourcemanager.projects.get`.
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
  ##            : The `next_page_token` value returned from a previous List request, if any.
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
  ##   parent: JString
  ##         : The name of the resource to list all attached Liens.
  ## For example, `projects/1234`.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of items to return. This is a suggestion for the server.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_597804 = query.getOrDefault("upload_protocol")
  valid_597804 = validateParameter(valid_597804, JString, required = false,
                                 default = nil)
  if valid_597804 != nil:
    section.add "upload_protocol", valid_597804
  var valid_597805 = query.getOrDefault("fields")
  valid_597805 = validateParameter(valid_597805, JString, required = false,
                                 default = nil)
  if valid_597805 != nil:
    section.add "fields", valid_597805
  var valid_597806 = query.getOrDefault("pageToken")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "pageToken", valid_597806
  var valid_597807 = query.getOrDefault("quotaUser")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "quotaUser", valid_597807
  var valid_597821 = query.getOrDefault("alt")
  valid_597821 = validateParameter(valid_597821, JString, required = false,
                                 default = newJString("json"))
  if valid_597821 != nil:
    section.add "alt", valid_597821
  var valid_597822 = query.getOrDefault("oauth_token")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = nil)
  if valid_597822 != nil:
    section.add "oauth_token", valid_597822
  var valid_597823 = query.getOrDefault("callback")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "callback", valid_597823
  var valid_597824 = query.getOrDefault("access_token")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "access_token", valid_597824
  var valid_597825 = query.getOrDefault("uploadType")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "uploadType", valid_597825
  var valid_597826 = query.getOrDefault("parent")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "parent", valid_597826
  var valid_597827 = query.getOrDefault("key")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "key", valid_597827
  var valid_597828 = query.getOrDefault("$.xgafv")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = newJString("1"))
  if valid_597828 != nil:
    section.add "$.xgafv", valid_597828
  var valid_597829 = query.getOrDefault("pageSize")
  valid_597829 = validateParameter(valid_597829, JInt, required = false, default = nil)
  if valid_597829 != nil:
    section.add "pageSize", valid_597829
  var valid_597830 = query.getOrDefault("prettyPrint")
  valid_597830 = validateParameter(valid_597830, JBool, required = false,
                                 default = newJBool(true))
  if valid_597830 != nil:
    section.add "prettyPrint", valid_597830
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597853: Call_CloudresourcemanagerLiensList_597690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all Liens applied to the `parent` resource.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, a Lien with a `parent` of `projects/1234` requires permission
  ## `resourcemanager.projects.get`.
  ## 
  let valid = call_597853.validator(path, query, header, formData, body)
  let scheme = call_597853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597853.url(scheme.get, call_597853.host, call_597853.base,
                         call_597853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597853, url, valid)

proc call*(call_597924: Call_CloudresourcemanagerLiensList_597690;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          parent: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerLiensList
  ## List all Liens applied to the `parent` resource.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, a Lien with a `parent` of `projects/1234` requires permission
  ## `resourcemanager.projects.get`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The `next_page_token` value returned from a previous List request, if any.
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
  ##   parent: string
  ##         : The name of the resource to list all attached Liens.
  ## For example, `projects/1234`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return. This is a suggestion for the server.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_597925 = newJObject()
  add(query_597925, "upload_protocol", newJString(uploadProtocol))
  add(query_597925, "fields", newJString(fields))
  add(query_597925, "pageToken", newJString(pageToken))
  add(query_597925, "quotaUser", newJString(quotaUser))
  add(query_597925, "alt", newJString(alt))
  add(query_597925, "oauth_token", newJString(oauthToken))
  add(query_597925, "callback", newJString(callback))
  add(query_597925, "access_token", newJString(accessToken))
  add(query_597925, "uploadType", newJString(uploadType))
  add(query_597925, "parent", newJString(parent))
  add(query_597925, "key", newJString(key))
  add(query_597925, "$.xgafv", newJString(Xgafv))
  add(query_597925, "pageSize", newJInt(pageSize))
  add(query_597925, "prettyPrint", newJBool(prettyPrint))
  result = call_597924.call(nil, query_597925, nil, nil, nil)

var cloudresourcemanagerLiensList* = Call_CloudresourcemanagerLiensList_597690(
    name: "cloudresourcemanagerLiensList", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/liens",
    validator: validate_CloudresourcemanagerLiensList_597691, base: "/",
    url: url_CloudresourcemanagerLiensList_597692, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsSearch_597984 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerOrganizationsSearch_597986(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerOrganizationsSearch_597985(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Searches Organization resources that are visible to the user and satisfy
  ## the specified filter. This method returns Organizations in an unspecified
  ## order. New Organizations do not necessarily appear at the end of the
  ## results.
  ## 
  ## Search will only return organizations on which the user has the permission
  ## `resourcemanager.organizations.get`
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
  var valid_597987 = query.getOrDefault("upload_protocol")
  valid_597987 = validateParameter(valid_597987, JString, required = false,
                                 default = nil)
  if valid_597987 != nil:
    section.add "upload_protocol", valid_597987
  var valid_597988 = query.getOrDefault("fields")
  valid_597988 = validateParameter(valid_597988, JString, required = false,
                                 default = nil)
  if valid_597988 != nil:
    section.add "fields", valid_597988
  var valid_597989 = query.getOrDefault("quotaUser")
  valid_597989 = validateParameter(valid_597989, JString, required = false,
                                 default = nil)
  if valid_597989 != nil:
    section.add "quotaUser", valid_597989
  var valid_597990 = query.getOrDefault("alt")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = newJString("json"))
  if valid_597990 != nil:
    section.add "alt", valid_597990
  var valid_597991 = query.getOrDefault("oauth_token")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = nil)
  if valid_597991 != nil:
    section.add "oauth_token", valid_597991
  var valid_597992 = query.getOrDefault("callback")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "callback", valid_597992
  var valid_597993 = query.getOrDefault("access_token")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "access_token", valid_597993
  var valid_597994 = query.getOrDefault("uploadType")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "uploadType", valid_597994
  var valid_597995 = query.getOrDefault("key")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "key", valid_597995
  var valid_597996 = query.getOrDefault("$.xgafv")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = newJString("1"))
  if valid_597996 != nil:
    section.add "$.xgafv", valid_597996
  var valid_597997 = query.getOrDefault("prettyPrint")
  valid_597997 = validateParameter(valid_597997, JBool, required = false,
                                 default = newJBool(true))
  if valid_597997 != nil:
    section.add "prettyPrint", valid_597997
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

proc call*(call_597999: Call_CloudresourcemanagerOrganizationsSearch_597984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Searches Organization resources that are visible to the user and satisfy
  ## the specified filter. This method returns Organizations in an unspecified
  ## order. New Organizations do not necessarily appear at the end of the
  ## results.
  ## 
  ## Search will only return organizations on which the user has the permission
  ## `resourcemanager.organizations.get`
  ## 
  let valid = call_597999.validator(path, query, header, formData, body)
  let scheme = call_597999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597999.url(scheme.get, call_597999.host, call_597999.base,
                         call_597999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597999, url, valid)

proc call*(call_598000: Call_CloudresourcemanagerOrganizationsSearch_597984;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsSearch
  ## Searches Organization resources that are visible to the user and satisfy
  ## the specified filter. This method returns Organizations in an unspecified
  ## order. New Organizations do not necessarily appear at the end of the
  ## results.
  ## 
  ## Search will only return organizations on which the user has the permission
  ## `resourcemanager.organizations.get`
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
  var query_598001 = newJObject()
  var body_598002 = newJObject()
  add(query_598001, "upload_protocol", newJString(uploadProtocol))
  add(query_598001, "fields", newJString(fields))
  add(query_598001, "quotaUser", newJString(quotaUser))
  add(query_598001, "alt", newJString(alt))
  add(query_598001, "oauth_token", newJString(oauthToken))
  add(query_598001, "callback", newJString(callback))
  add(query_598001, "access_token", newJString(accessToken))
  add(query_598001, "uploadType", newJString(uploadType))
  add(query_598001, "key", newJString(key))
  add(query_598001, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598002 = body
  add(query_598001, "prettyPrint", newJBool(prettyPrint))
  result = call_598000.call(nil, query_598001, nil, nil, body_598002)

var cloudresourcemanagerOrganizationsSearch* = Call_CloudresourcemanagerOrganizationsSearch_597984(
    name: "cloudresourcemanagerOrganizationsSearch", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/organizations:search",
    validator: validate_CloudresourcemanagerOrganizationsSearch_597985, base: "/",
    url: url_CloudresourcemanagerOrganizationsSearch_597986,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsCreate_598023 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerProjectsCreate_598025(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerProjectsCreate_598024(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Request that a new Project be created. The result is an Operation which
  ## can be used to track the creation process. This process usually takes a few
  ## seconds, but can sometimes take much longer. The tracking Operation is
  ## automatically deleted after a few hours, so there is no need to call
  ## DeleteOperation.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.create` on the specified parent for the new
  ## project. The parent is identified by a specified ResourceId,
  ## which must include both an ID and a type, such as organization.
  ## 
  ## This method does not associate the new project with a billing account.
  ## You can set or update the billing account associated with a project using
  ## the [`projects.updateBillingInfo`]
  ## (/billing/reference/rest/v1/projects/updateBillingInfo) method.
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
  var valid_598026 = query.getOrDefault("upload_protocol")
  valid_598026 = validateParameter(valid_598026, JString, required = false,
                                 default = nil)
  if valid_598026 != nil:
    section.add "upload_protocol", valid_598026
  var valid_598027 = query.getOrDefault("fields")
  valid_598027 = validateParameter(valid_598027, JString, required = false,
                                 default = nil)
  if valid_598027 != nil:
    section.add "fields", valid_598027
  var valid_598028 = query.getOrDefault("quotaUser")
  valid_598028 = validateParameter(valid_598028, JString, required = false,
                                 default = nil)
  if valid_598028 != nil:
    section.add "quotaUser", valid_598028
  var valid_598029 = query.getOrDefault("alt")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = newJString("json"))
  if valid_598029 != nil:
    section.add "alt", valid_598029
  var valid_598030 = query.getOrDefault("oauth_token")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "oauth_token", valid_598030
  var valid_598031 = query.getOrDefault("callback")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "callback", valid_598031
  var valid_598032 = query.getOrDefault("access_token")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "access_token", valid_598032
  var valid_598033 = query.getOrDefault("uploadType")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "uploadType", valid_598033
  var valid_598034 = query.getOrDefault("key")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "key", valid_598034
  var valid_598035 = query.getOrDefault("$.xgafv")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = newJString("1"))
  if valid_598035 != nil:
    section.add "$.xgafv", valid_598035
  var valid_598036 = query.getOrDefault("prettyPrint")
  valid_598036 = validateParameter(valid_598036, JBool, required = false,
                                 default = newJBool(true))
  if valid_598036 != nil:
    section.add "prettyPrint", valid_598036
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

proc call*(call_598038: Call_CloudresourcemanagerProjectsCreate_598023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Request that a new Project be created. The result is an Operation which
  ## can be used to track the creation process. This process usually takes a few
  ## seconds, but can sometimes take much longer. The tracking Operation is
  ## automatically deleted after a few hours, so there is no need to call
  ## DeleteOperation.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.create` on the specified parent for the new
  ## project. The parent is identified by a specified ResourceId,
  ## which must include both an ID and a type, such as organization.
  ## 
  ## This method does not associate the new project with a billing account.
  ## You can set or update the billing account associated with a project using
  ## the [`projects.updateBillingInfo`]
  ## (/billing/reference/rest/v1/projects/updateBillingInfo) method.
  ## 
  let valid = call_598038.validator(path, query, header, formData, body)
  let scheme = call_598038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598038.url(scheme.get, call_598038.host, call_598038.base,
                         call_598038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598038, url, valid)

proc call*(call_598039: Call_CloudresourcemanagerProjectsCreate_598023;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsCreate
  ## Request that a new Project be created. The result is an Operation which
  ## can be used to track the creation process. This process usually takes a few
  ## seconds, but can sometimes take much longer. The tracking Operation is
  ## automatically deleted after a few hours, so there is no need to call
  ## DeleteOperation.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.create` on the specified parent for the new
  ## project. The parent is identified by a specified ResourceId,
  ## which must include both an ID and a type, such as organization.
  ## 
  ## This method does not associate the new project with a billing account.
  ## You can set or update the billing account associated with a project using
  ## the [`projects.updateBillingInfo`]
  ## (/billing/reference/rest/v1/projects/updateBillingInfo) method.
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
  var query_598040 = newJObject()
  var body_598041 = newJObject()
  add(query_598040, "upload_protocol", newJString(uploadProtocol))
  add(query_598040, "fields", newJString(fields))
  add(query_598040, "quotaUser", newJString(quotaUser))
  add(query_598040, "alt", newJString(alt))
  add(query_598040, "oauth_token", newJString(oauthToken))
  add(query_598040, "callback", newJString(callback))
  add(query_598040, "access_token", newJString(accessToken))
  add(query_598040, "uploadType", newJString(uploadType))
  add(query_598040, "key", newJString(key))
  add(query_598040, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598041 = body
  add(query_598040, "prettyPrint", newJBool(prettyPrint))
  result = call_598039.call(nil, query_598040, nil, nil, body_598041)

var cloudresourcemanagerProjectsCreate* = Call_CloudresourcemanagerProjectsCreate_598023(
    name: "cloudresourcemanagerProjectsCreate", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/projects",
    validator: validate_CloudresourcemanagerProjectsCreate_598024, base: "/",
    url: url_CloudresourcemanagerProjectsCreate_598025, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsList_598003 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerProjectsList_598005(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerProjectsList_598004(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists Projects that the caller has the `resourcemanager.projects.get`
  ## permission on and satisfy the specified filter.
  ## 
  ## This method returns Projects in an unspecified order.
  ## This method is eventually consistent with project mutations; this means
  ## that a newly created project may not appear in the results or recent
  ## updates to an existing project may not be reflected in the results. To
  ## retrieve the latest state of a project, use the
  ## GetProject method.
  ## 
  ## NOTE: If the request filter contains a `parent.type` and `parent.id` and
  ## the caller has the `resourcemanager.projects.list` permission on the
  ## parent, the results will be drawn from an alternate index which provides
  ## more consistent results. In future versions of this API, this List method
  ## will be split into List and Search to properly capture the behavorial
  ## difference.
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
  ##            : A pagination token returned from a previous call to ListProjects
  ## that indicates from where listing should continue.
  ## 
  ## Optional.
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
  ##   pageSize: JInt
  ##           : The maximum number of Projects to return in the response.
  ## The server can return fewer Projects than requested.
  ## If unspecified, server picks an appropriate default.
  ## 
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : An expression for filtering the results of the request.  Filter rules are
  ## case insensitive. The fields eligible for filtering are:
  ## 
  ## + `name`
  ## + `id`
  ## + `labels.<key>` (where *key* is the name of a label)
  ## + `parent.type`
  ## + `parent.id`
  ## 
  ## Some examples of using labels as filters:
  ## 
  ## | Filter           | Description                                         |
  ## |------------------|-----------------------------------------------------|
  ## | name:how*        | The project's name starts with "how".               |
  ## | name:Howl        | The project's name is `Howl` or `howl`.             |
  ## | name:HOWL        | Equivalent to above.                                |
  ## | NAME:howl        | Equivalent to above.                                |
  ## | labels.color:*   | The project has the label `color`.                  |
  ## | labels.color:red | The project's label `color` has the value `red`.    |
  ## | labels.color:red&nbsp;labels.size:big |The project's label `color` has
  ##   the value `red` and its label `size` has the value `big`.              |
  ## 
  ## If no filter is specified, the call will return projects for which the user
  ## has the `resourcemanager.projects.get` permission.
  ## 
  ## NOTE: To perform a by-parent query (eg., what projects are directly in a
  ## Folder), the caller must have the `resourcemanager.projects.list`
  ## permission on the parent and the filter must contain both a `parent.type`
  ## and a `parent.id` restriction
  ## (example: "parent.type:folder parent.id:123"). In this case an alternate
  ## search index is used which provides more consistent results.
  ## 
  ## Optional.
  section = newJObject()
  var valid_598006 = query.getOrDefault("upload_protocol")
  valid_598006 = validateParameter(valid_598006, JString, required = false,
                                 default = nil)
  if valid_598006 != nil:
    section.add "upload_protocol", valid_598006
  var valid_598007 = query.getOrDefault("fields")
  valid_598007 = validateParameter(valid_598007, JString, required = false,
                                 default = nil)
  if valid_598007 != nil:
    section.add "fields", valid_598007
  var valid_598008 = query.getOrDefault("pageToken")
  valid_598008 = validateParameter(valid_598008, JString, required = false,
                                 default = nil)
  if valid_598008 != nil:
    section.add "pageToken", valid_598008
  var valid_598009 = query.getOrDefault("quotaUser")
  valid_598009 = validateParameter(valid_598009, JString, required = false,
                                 default = nil)
  if valid_598009 != nil:
    section.add "quotaUser", valid_598009
  var valid_598010 = query.getOrDefault("alt")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = newJString("json"))
  if valid_598010 != nil:
    section.add "alt", valid_598010
  var valid_598011 = query.getOrDefault("oauth_token")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "oauth_token", valid_598011
  var valid_598012 = query.getOrDefault("callback")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "callback", valid_598012
  var valid_598013 = query.getOrDefault("access_token")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "access_token", valid_598013
  var valid_598014 = query.getOrDefault("uploadType")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "uploadType", valid_598014
  var valid_598015 = query.getOrDefault("key")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "key", valid_598015
  var valid_598016 = query.getOrDefault("$.xgafv")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = newJString("1"))
  if valid_598016 != nil:
    section.add "$.xgafv", valid_598016
  var valid_598017 = query.getOrDefault("pageSize")
  valid_598017 = validateParameter(valid_598017, JInt, required = false, default = nil)
  if valid_598017 != nil:
    section.add "pageSize", valid_598017
  var valid_598018 = query.getOrDefault("prettyPrint")
  valid_598018 = validateParameter(valid_598018, JBool, required = false,
                                 default = newJBool(true))
  if valid_598018 != nil:
    section.add "prettyPrint", valid_598018
  var valid_598019 = query.getOrDefault("filter")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "filter", valid_598019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598020: Call_CloudresourcemanagerProjectsList_598003;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Projects that the caller has the `resourcemanager.projects.get`
  ## permission on and satisfy the specified filter.
  ## 
  ## This method returns Projects in an unspecified order.
  ## This method is eventually consistent with project mutations; this means
  ## that a newly created project may not appear in the results or recent
  ## updates to an existing project may not be reflected in the results. To
  ## retrieve the latest state of a project, use the
  ## GetProject method.
  ## 
  ## NOTE: If the request filter contains a `parent.type` and `parent.id` and
  ## the caller has the `resourcemanager.projects.list` permission on the
  ## parent, the results will be drawn from an alternate index which provides
  ## more consistent results. In future versions of this API, this List method
  ## will be split into List and Search to properly capture the behavorial
  ## difference.
  ## 
  let valid = call_598020.validator(path, query, header, formData, body)
  let scheme = call_598020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598020.url(scheme.get, call_598020.host, call_598020.base,
                         call_598020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598020, url, valid)

proc call*(call_598021: Call_CloudresourcemanagerProjectsList_598003;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## cloudresourcemanagerProjectsList
  ## Lists Projects that the caller has the `resourcemanager.projects.get`
  ## permission on and satisfy the specified filter.
  ## 
  ## This method returns Projects in an unspecified order.
  ## This method is eventually consistent with project mutations; this means
  ## that a newly created project may not appear in the results or recent
  ## updates to an existing project may not be reflected in the results. To
  ## retrieve the latest state of a project, use the
  ## GetProject method.
  ## 
  ## NOTE: If the request filter contains a `parent.type` and `parent.id` and
  ## the caller has the `resourcemanager.projects.list` permission on the
  ## parent, the results will be drawn from an alternate index which provides
  ## more consistent results. In future versions of this API, this List method
  ## will be split into List and Search to properly capture the behavorial
  ## difference.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to ListProjects
  ## that indicates from where listing should continue.
  ## 
  ## Optional.
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
  ##   pageSize: int
  ##           : The maximum number of Projects to return in the response.
  ## The server can return fewer Projects than requested.
  ## If unspecified, server picks an appropriate default.
  ## 
  ## Optional.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : An expression for filtering the results of the request.  Filter rules are
  ## case insensitive. The fields eligible for filtering are:
  ## 
  ## + `name`
  ## + `id`
  ## + `labels.<key>` (where *key* is the name of a label)
  ## + `parent.type`
  ## + `parent.id`
  ## 
  ## Some examples of using labels as filters:
  ## 
  ## | Filter           | Description                                         |
  ## |------------------|-----------------------------------------------------|
  ## | name:how*        | The project's name starts with "how".               |
  ## | name:Howl        | The project's name is `Howl` or `howl`.             |
  ## | name:HOWL        | Equivalent to above.                                |
  ## | NAME:howl        | Equivalent to above.                                |
  ## | labels.color:*   | The project has the label `color`.                  |
  ## | labels.color:red | The project's label `color` has the value `red`.    |
  ## | labels.color:red&nbsp;labels.size:big |The project's label `color` has
  ##   the value `red` and its label `size` has the value `big`.              |
  ## 
  ## If no filter is specified, the call will return projects for which the user
  ## has the `resourcemanager.projects.get` permission.
  ## 
  ## NOTE: To perform a by-parent query (eg., what projects are directly in a
  ## Folder), the caller must have the `resourcemanager.projects.list`
  ## permission on the parent and the filter must contain both a `parent.type`
  ## and a `parent.id` restriction
  ## (example: "parent.type:folder parent.id:123"). In this case an alternate
  ## search index is used which provides more consistent results.
  ## 
  ## Optional.
  var query_598022 = newJObject()
  add(query_598022, "upload_protocol", newJString(uploadProtocol))
  add(query_598022, "fields", newJString(fields))
  add(query_598022, "pageToken", newJString(pageToken))
  add(query_598022, "quotaUser", newJString(quotaUser))
  add(query_598022, "alt", newJString(alt))
  add(query_598022, "oauth_token", newJString(oauthToken))
  add(query_598022, "callback", newJString(callback))
  add(query_598022, "access_token", newJString(accessToken))
  add(query_598022, "uploadType", newJString(uploadType))
  add(query_598022, "key", newJString(key))
  add(query_598022, "$.xgafv", newJString(Xgafv))
  add(query_598022, "pageSize", newJInt(pageSize))
  add(query_598022, "prettyPrint", newJBool(prettyPrint))
  add(query_598022, "filter", newJString(filter))
  result = call_598021.call(nil, query_598022, nil, nil, nil)

var cloudresourcemanagerProjectsList* = Call_CloudresourcemanagerProjectsList_598003(
    name: "cloudresourcemanagerProjectsList", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/projects",
    validator: validate_CloudresourcemanagerProjectsList_598004, base: "/",
    url: url_CloudresourcemanagerProjectsList_598005, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsUpdate_598075 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerProjectsUpdate_598077(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsUpdate_598076(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the attributes of the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The project ID (for example, `my-project-123`).
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_598078 = path.getOrDefault("projectId")
  valid_598078 = validateParameter(valid_598078, JString, required = true,
                                 default = nil)
  if valid_598078 != nil:
    section.add "projectId", valid_598078
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
  var valid_598079 = query.getOrDefault("upload_protocol")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "upload_protocol", valid_598079
  var valid_598080 = query.getOrDefault("fields")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = nil)
  if valid_598080 != nil:
    section.add "fields", valid_598080
  var valid_598081 = query.getOrDefault("quotaUser")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = nil)
  if valid_598081 != nil:
    section.add "quotaUser", valid_598081
  var valid_598082 = query.getOrDefault("alt")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = newJString("json"))
  if valid_598082 != nil:
    section.add "alt", valid_598082
  var valid_598083 = query.getOrDefault("oauth_token")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = nil)
  if valid_598083 != nil:
    section.add "oauth_token", valid_598083
  var valid_598084 = query.getOrDefault("callback")
  valid_598084 = validateParameter(valid_598084, JString, required = false,
                                 default = nil)
  if valid_598084 != nil:
    section.add "callback", valid_598084
  var valid_598085 = query.getOrDefault("access_token")
  valid_598085 = validateParameter(valid_598085, JString, required = false,
                                 default = nil)
  if valid_598085 != nil:
    section.add "access_token", valid_598085
  var valid_598086 = query.getOrDefault("uploadType")
  valid_598086 = validateParameter(valid_598086, JString, required = false,
                                 default = nil)
  if valid_598086 != nil:
    section.add "uploadType", valid_598086
  var valid_598087 = query.getOrDefault("key")
  valid_598087 = validateParameter(valid_598087, JString, required = false,
                                 default = nil)
  if valid_598087 != nil:
    section.add "key", valid_598087
  var valid_598088 = query.getOrDefault("$.xgafv")
  valid_598088 = validateParameter(valid_598088, JString, required = false,
                                 default = newJString("1"))
  if valid_598088 != nil:
    section.add "$.xgafv", valid_598088
  var valid_598089 = query.getOrDefault("prettyPrint")
  valid_598089 = validateParameter(valid_598089, JBool, required = false,
                                 default = newJBool(true))
  if valid_598089 != nil:
    section.add "prettyPrint", valid_598089
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

proc call*(call_598091: Call_CloudresourcemanagerProjectsUpdate_598075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the attributes of the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  let valid = call_598091.validator(path, query, header, formData, body)
  let scheme = call_598091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598091.url(scheme.get, call_598091.host, call_598091.base,
                         call_598091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598091, url, valid)

proc call*(call_598092: Call_CloudresourcemanagerProjectsUpdate_598075;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsUpdate
  ## Updates the attributes of the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have modify permissions for this Project.
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
  ##   projectId: string (required)
  ##            : The project ID (for example, `my-project-123`).
  ## 
  ## Required.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598093 = newJObject()
  var query_598094 = newJObject()
  var body_598095 = newJObject()
  add(query_598094, "upload_protocol", newJString(uploadProtocol))
  add(query_598094, "fields", newJString(fields))
  add(query_598094, "quotaUser", newJString(quotaUser))
  add(query_598094, "alt", newJString(alt))
  add(query_598094, "oauth_token", newJString(oauthToken))
  add(query_598094, "callback", newJString(callback))
  add(query_598094, "access_token", newJString(accessToken))
  add(query_598094, "uploadType", newJString(uploadType))
  add(query_598094, "key", newJString(key))
  add(path_598093, "projectId", newJString(projectId))
  add(query_598094, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598095 = body
  add(query_598094, "prettyPrint", newJBool(prettyPrint))
  result = call_598092.call(path_598093, query_598094, nil, nil, body_598095)

var cloudresourcemanagerProjectsUpdate* = Call_CloudresourcemanagerProjectsUpdate_598075(
    name: "cloudresourcemanagerProjectsUpdate", meth: HttpMethod.HttpPut,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{projectId}",
    validator: validate_CloudresourcemanagerProjectsUpdate_598076, base: "/",
    url: url_CloudresourcemanagerProjectsUpdate_598077, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsGet_598042 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerProjectsGet_598044(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsGet_598043(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Project ID (for example, `my-project-123`).
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_598059 = path.getOrDefault("projectId")
  valid_598059 = validateParameter(valid_598059, JString, required = true,
                                 default = nil)
  if valid_598059 != nil:
    section.add "projectId", valid_598059
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
  var valid_598060 = query.getOrDefault("upload_protocol")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "upload_protocol", valid_598060
  var valid_598061 = query.getOrDefault("fields")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = nil)
  if valid_598061 != nil:
    section.add "fields", valid_598061
  var valid_598062 = query.getOrDefault("quotaUser")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = nil)
  if valid_598062 != nil:
    section.add "quotaUser", valid_598062
  var valid_598063 = query.getOrDefault("alt")
  valid_598063 = validateParameter(valid_598063, JString, required = false,
                                 default = newJString("json"))
  if valid_598063 != nil:
    section.add "alt", valid_598063
  var valid_598064 = query.getOrDefault("oauth_token")
  valid_598064 = validateParameter(valid_598064, JString, required = false,
                                 default = nil)
  if valid_598064 != nil:
    section.add "oauth_token", valid_598064
  var valid_598065 = query.getOrDefault("callback")
  valid_598065 = validateParameter(valid_598065, JString, required = false,
                                 default = nil)
  if valid_598065 != nil:
    section.add "callback", valid_598065
  var valid_598066 = query.getOrDefault("access_token")
  valid_598066 = validateParameter(valid_598066, JString, required = false,
                                 default = nil)
  if valid_598066 != nil:
    section.add "access_token", valid_598066
  var valid_598067 = query.getOrDefault("uploadType")
  valid_598067 = validateParameter(valid_598067, JString, required = false,
                                 default = nil)
  if valid_598067 != nil:
    section.add "uploadType", valid_598067
  var valid_598068 = query.getOrDefault("key")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = nil)
  if valid_598068 != nil:
    section.add "key", valid_598068
  var valid_598069 = query.getOrDefault("$.xgafv")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = newJString("1"))
  if valid_598069 != nil:
    section.add "$.xgafv", valid_598069
  var valid_598070 = query.getOrDefault("prettyPrint")
  valid_598070 = validateParameter(valid_598070, JBool, required = false,
                                 default = newJBool(true))
  if valid_598070 != nil:
    section.add "prettyPrint", valid_598070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598071: Call_CloudresourcemanagerProjectsGet_598042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
  ## 
  let valid = call_598071.validator(path, query, header, formData, body)
  let scheme = call_598071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598071.url(scheme.get, call_598071.host, call_598071.base,
                         call_598071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598071, url, valid)

proc call*(call_598072: Call_CloudresourcemanagerProjectsGet_598042;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsGet
  ## Retrieves the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
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
  ##   projectId: string (required)
  ##            : The Project ID (for example, `my-project-123`).
  ## 
  ## Required.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598073 = newJObject()
  var query_598074 = newJObject()
  add(query_598074, "upload_protocol", newJString(uploadProtocol))
  add(query_598074, "fields", newJString(fields))
  add(query_598074, "quotaUser", newJString(quotaUser))
  add(query_598074, "alt", newJString(alt))
  add(query_598074, "oauth_token", newJString(oauthToken))
  add(query_598074, "callback", newJString(callback))
  add(query_598074, "access_token", newJString(accessToken))
  add(query_598074, "uploadType", newJString(uploadType))
  add(query_598074, "key", newJString(key))
  add(path_598073, "projectId", newJString(projectId))
  add(query_598074, "$.xgafv", newJString(Xgafv))
  add(query_598074, "prettyPrint", newJBool(prettyPrint))
  result = call_598072.call(path_598073, query_598074, nil, nil, nil)

var cloudresourcemanagerProjectsGet* = Call_CloudresourcemanagerProjectsGet_598042(
    name: "cloudresourcemanagerProjectsGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{projectId}",
    validator: validate_CloudresourcemanagerProjectsGet_598043, base: "/",
    url: url_CloudresourcemanagerProjectsGet_598044, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsDelete_598096 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerProjectsDelete_598098(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsDelete_598097(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Marks the Project identified by the specified
  ## `project_id` (for example, `my-project-123`) for deletion.
  ## This method will only affect the Project if it has a lifecycle state of
  ## ACTIVE.
  ## 
  ## This method changes the Project's lifecycle state from
  ## ACTIVE
  ## to DELETE_REQUESTED.
  ## The deletion starts at an unspecified time,
  ## at which point the Project is no longer accessible.
  ## 
  ## Until the deletion completes, you can check the lifecycle state
  ## checked by retrieving the Project with GetProject,
  ## and the Project remains visible to ListProjects.
  ## However, you cannot update the project.
  ## 
  ## After the deletion completes, the Project is not retrievable by
  ## the  GetProject and
  ## ListProjects methods.
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Project ID (for example, `foo-bar-123`).
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_598099 = path.getOrDefault("projectId")
  valid_598099 = validateParameter(valid_598099, JString, required = true,
                                 default = nil)
  if valid_598099 != nil:
    section.add "projectId", valid_598099
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
  var valid_598100 = query.getOrDefault("upload_protocol")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "upload_protocol", valid_598100
  var valid_598101 = query.getOrDefault("fields")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "fields", valid_598101
  var valid_598102 = query.getOrDefault("quotaUser")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = nil)
  if valid_598102 != nil:
    section.add "quotaUser", valid_598102
  var valid_598103 = query.getOrDefault("alt")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = newJString("json"))
  if valid_598103 != nil:
    section.add "alt", valid_598103
  var valid_598104 = query.getOrDefault("oauth_token")
  valid_598104 = validateParameter(valid_598104, JString, required = false,
                                 default = nil)
  if valid_598104 != nil:
    section.add "oauth_token", valid_598104
  var valid_598105 = query.getOrDefault("callback")
  valid_598105 = validateParameter(valid_598105, JString, required = false,
                                 default = nil)
  if valid_598105 != nil:
    section.add "callback", valid_598105
  var valid_598106 = query.getOrDefault("access_token")
  valid_598106 = validateParameter(valid_598106, JString, required = false,
                                 default = nil)
  if valid_598106 != nil:
    section.add "access_token", valid_598106
  var valid_598107 = query.getOrDefault("uploadType")
  valid_598107 = validateParameter(valid_598107, JString, required = false,
                                 default = nil)
  if valid_598107 != nil:
    section.add "uploadType", valid_598107
  var valid_598108 = query.getOrDefault("key")
  valid_598108 = validateParameter(valid_598108, JString, required = false,
                                 default = nil)
  if valid_598108 != nil:
    section.add "key", valid_598108
  var valid_598109 = query.getOrDefault("$.xgafv")
  valid_598109 = validateParameter(valid_598109, JString, required = false,
                                 default = newJString("1"))
  if valid_598109 != nil:
    section.add "$.xgafv", valid_598109
  var valid_598110 = query.getOrDefault("prettyPrint")
  valid_598110 = validateParameter(valid_598110, JBool, required = false,
                                 default = newJBool(true))
  if valid_598110 != nil:
    section.add "prettyPrint", valid_598110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598111: Call_CloudresourcemanagerProjectsDelete_598096;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Marks the Project identified by the specified
  ## `project_id` (for example, `my-project-123`) for deletion.
  ## This method will only affect the Project if it has a lifecycle state of
  ## ACTIVE.
  ## 
  ## This method changes the Project's lifecycle state from
  ## ACTIVE
  ## to DELETE_REQUESTED.
  ## The deletion starts at an unspecified time,
  ## at which point the Project is no longer accessible.
  ## 
  ## Until the deletion completes, you can check the lifecycle state
  ## checked by retrieving the Project with GetProject,
  ## and the Project remains visible to ListProjects.
  ## However, you cannot update the project.
  ## 
  ## After the deletion completes, the Project is not retrievable by
  ## the  GetProject and
  ## ListProjects methods.
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  let valid = call_598111.validator(path, query, header, formData, body)
  let scheme = call_598111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598111.url(scheme.get, call_598111.host, call_598111.base,
                         call_598111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598111, url, valid)

proc call*(call_598112: Call_CloudresourcemanagerProjectsDelete_598096;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsDelete
  ## Marks the Project identified by the specified
  ## `project_id` (for example, `my-project-123`) for deletion.
  ## This method will only affect the Project if it has a lifecycle state of
  ## ACTIVE.
  ## 
  ## This method changes the Project's lifecycle state from
  ## ACTIVE
  ## to DELETE_REQUESTED.
  ## The deletion starts at an unspecified time,
  ## at which point the Project is no longer accessible.
  ## 
  ## Until the deletion completes, you can check the lifecycle state
  ## checked by retrieving the Project with GetProject,
  ## and the Project remains visible to ListProjects.
  ## However, you cannot update the project.
  ## 
  ## After the deletion completes, the Project is not retrievable by
  ## the  GetProject and
  ## ListProjects methods.
  ## 
  ## The caller must have modify permissions for this Project.
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
  ##   projectId: string (required)
  ##            : The Project ID (for example, `foo-bar-123`).
  ## 
  ## Required.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598113 = newJObject()
  var query_598114 = newJObject()
  add(query_598114, "upload_protocol", newJString(uploadProtocol))
  add(query_598114, "fields", newJString(fields))
  add(query_598114, "quotaUser", newJString(quotaUser))
  add(query_598114, "alt", newJString(alt))
  add(query_598114, "oauth_token", newJString(oauthToken))
  add(query_598114, "callback", newJString(callback))
  add(query_598114, "access_token", newJString(accessToken))
  add(query_598114, "uploadType", newJString(uploadType))
  add(query_598114, "key", newJString(key))
  add(path_598113, "projectId", newJString(projectId))
  add(query_598114, "$.xgafv", newJString(Xgafv))
  add(query_598114, "prettyPrint", newJBool(prettyPrint))
  result = call_598112.call(path_598113, query_598114, nil, nil, nil)

var cloudresourcemanagerProjectsDelete* = Call_CloudresourcemanagerProjectsDelete_598096(
    name: "cloudresourcemanagerProjectsDelete", meth: HttpMethod.HttpDelete,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{projectId}",
    validator: validate_CloudresourcemanagerProjectsDelete_598097, base: "/",
    url: url_CloudresourcemanagerProjectsDelete_598098, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsGetAncestry_598115 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerProjectsGetAncestry_598117(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: ":getAncestry")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsGetAncestry_598116(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of ancestors in the resource hierarchy for the Project
  ## identified by the specified `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Project ID (for example, `my-project-123`).
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_598118 = path.getOrDefault("projectId")
  valid_598118 = validateParameter(valid_598118, JString, required = true,
                                 default = nil)
  if valid_598118 != nil:
    section.add "projectId", valid_598118
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
  var valid_598119 = query.getOrDefault("upload_protocol")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = nil)
  if valid_598119 != nil:
    section.add "upload_protocol", valid_598119
  var valid_598120 = query.getOrDefault("fields")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = nil)
  if valid_598120 != nil:
    section.add "fields", valid_598120
  var valid_598121 = query.getOrDefault("quotaUser")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "quotaUser", valid_598121
  var valid_598122 = query.getOrDefault("alt")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = newJString("json"))
  if valid_598122 != nil:
    section.add "alt", valid_598122
  var valid_598123 = query.getOrDefault("oauth_token")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "oauth_token", valid_598123
  var valid_598124 = query.getOrDefault("callback")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = nil)
  if valid_598124 != nil:
    section.add "callback", valid_598124
  var valid_598125 = query.getOrDefault("access_token")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = nil)
  if valid_598125 != nil:
    section.add "access_token", valid_598125
  var valid_598126 = query.getOrDefault("uploadType")
  valid_598126 = validateParameter(valid_598126, JString, required = false,
                                 default = nil)
  if valid_598126 != nil:
    section.add "uploadType", valid_598126
  var valid_598127 = query.getOrDefault("key")
  valid_598127 = validateParameter(valid_598127, JString, required = false,
                                 default = nil)
  if valid_598127 != nil:
    section.add "key", valid_598127
  var valid_598128 = query.getOrDefault("$.xgafv")
  valid_598128 = validateParameter(valid_598128, JString, required = false,
                                 default = newJString("1"))
  if valid_598128 != nil:
    section.add "$.xgafv", valid_598128
  var valid_598129 = query.getOrDefault("prettyPrint")
  valid_598129 = validateParameter(valid_598129, JBool, required = false,
                                 default = newJBool(true))
  if valid_598129 != nil:
    section.add "prettyPrint", valid_598129
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

proc call*(call_598131: Call_CloudresourcemanagerProjectsGetAncestry_598115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of ancestors in the resource hierarchy for the Project
  ## identified by the specified `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
  ## 
  let valid = call_598131.validator(path, query, header, formData, body)
  let scheme = call_598131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598131.url(scheme.get, call_598131.host, call_598131.base,
                         call_598131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598131, url, valid)

proc call*(call_598132: Call_CloudresourcemanagerProjectsGetAncestry_598115;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsGetAncestry
  ## Gets a list of ancestors in the resource hierarchy for the Project
  ## identified by the specified `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
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
  ##   projectId: string (required)
  ##            : The Project ID (for example, `my-project-123`).
  ## 
  ## Required.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598133 = newJObject()
  var query_598134 = newJObject()
  var body_598135 = newJObject()
  add(query_598134, "upload_protocol", newJString(uploadProtocol))
  add(query_598134, "fields", newJString(fields))
  add(query_598134, "quotaUser", newJString(quotaUser))
  add(query_598134, "alt", newJString(alt))
  add(query_598134, "oauth_token", newJString(oauthToken))
  add(query_598134, "callback", newJString(callback))
  add(query_598134, "access_token", newJString(accessToken))
  add(query_598134, "uploadType", newJString(uploadType))
  add(query_598134, "key", newJString(key))
  add(path_598133, "projectId", newJString(projectId))
  add(query_598134, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598135 = body
  add(query_598134, "prettyPrint", newJBool(prettyPrint))
  result = call_598132.call(path_598133, query_598134, nil, nil, body_598135)

var cloudresourcemanagerProjectsGetAncestry* = Call_CloudresourcemanagerProjectsGetAncestry_598115(
    name: "cloudresourcemanagerProjectsGetAncestry", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{projectId}:getAncestry",
    validator: validate_CloudresourcemanagerProjectsGetAncestry_598116, base: "/",
    url: url_CloudresourcemanagerProjectsGetAncestry_598117,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsUndelete_598136 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerProjectsUndelete_598138(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: ":undelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsUndelete_598137(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restores the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## You can only use this method for a Project that has a lifecycle state of
  ## DELETE_REQUESTED.
  ## After deletion starts, the Project cannot be restored.
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The project ID (for example, `foo-bar-123`).
  ## 
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_598139 = path.getOrDefault("projectId")
  valid_598139 = validateParameter(valid_598139, JString, required = true,
                                 default = nil)
  if valid_598139 != nil:
    section.add "projectId", valid_598139
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
  var valid_598140 = query.getOrDefault("upload_protocol")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = nil)
  if valid_598140 != nil:
    section.add "upload_protocol", valid_598140
  var valid_598141 = query.getOrDefault("fields")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = nil)
  if valid_598141 != nil:
    section.add "fields", valid_598141
  var valid_598142 = query.getOrDefault("quotaUser")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "quotaUser", valid_598142
  var valid_598143 = query.getOrDefault("alt")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = newJString("json"))
  if valid_598143 != nil:
    section.add "alt", valid_598143
  var valid_598144 = query.getOrDefault("oauth_token")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = nil)
  if valid_598144 != nil:
    section.add "oauth_token", valid_598144
  var valid_598145 = query.getOrDefault("callback")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = nil)
  if valid_598145 != nil:
    section.add "callback", valid_598145
  var valid_598146 = query.getOrDefault("access_token")
  valid_598146 = validateParameter(valid_598146, JString, required = false,
                                 default = nil)
  if valid_598146 != nil:
    section.add "access_token", valid_598146
  var valid_598147 = query.getOrDefault("uploadType")
  valid_598147 = validateParameter(valid_598147, JString, required = false,
                                 default = nil)
  if valid_598147 != nil:
    section.add "uploadType", valid_598147
  var valid_598148 = query.getOrDefault("key")
  valid_598148 = validateParameter(valid_598148, JString, required = false,
                                 default = nil)
  if valid_598148 != nil:
    section.add "key", valid_598148
  var valid_598149 = query.getOrDefault("$.xgafv")
  valid_598149 = validateParameter(valid_598149, JString, required = false,
                                 default = newJString("1"))
  if valid_598149 != nil:
    section.add "$.xgafv", valid_598149
  var valid_598150 = query.getOrDefault("prettyPrint")
  valid_598150 = validateParameter(valid_598150, JBool, required = false,
                                 default = newJBool(true))
  if valid_598150 != nil:
    section.add "prettyPrint", valid_598150
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

proc call*(call_598152: Call_CloudresourcemanagerProjectsUndelete_598136;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Restores the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## You can only use this method for a Project that has a lifecycle state of
  ## DELETE_REQUESTED.
  ## After deletion starts, the Project cannot be restored.
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  let valid = call_598152.validator(path, query, header, formData, body)
  let scheme = call_598152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598152.url(scheme.get, call_598152.host, call_598152.base,
                         call_598152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598152, url, valid)

proc call*(call_598153: Call_CloudresourcemanagerProjectsUndelete_598136;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsUndelete
  ## Restores the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## You can only use this method for a Project that has a lifecycle state of
  ## DELETE_REQUESTED.
  ## After deletion starts, the Project cannot be restored.
  ## 
  ## The caller must have modify permissions for this Project.
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
  ##   projectId: string (required)
  ##            : The project ID (for example, `foo-bar-123`).
  ## 
  ## Required.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598154 = newJObject()
  var query_598155 = newJObject()
  var body_598156 = newJObject()
  add(query_598155, "upload_protocol", newJString(uploadProtocol))
  add(query_598155, "fields", newJString(fields))
  add(query_598155, "quotaUser", newJString(quotaUser))
  add(query_598155, "alt", newJString(alt))
  add(query_598155, "oauth_token", newJString(oauthToken))
  add(query_598155, "callback", newJString(callback))
  add(query_598155, "access_token", newJString(accessToken))
  add(query_598155, "uploadType", newJString(uploadType))
  add(query_598155, "key", newJString(key))
  add(path_598154, "projectId", newJString(projectId))
  add(query_598155, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598156 = body
  add(query_598155, "prettyPrint", newJBool(prettyPrint))
  result = call_598153.call(path_598154, query_598155, nil, nil, body_598156)

var cloudresourcemanagerProjectsUndelete* = Call_CloudresourcemanagerProjectsUndelete_598136(
    name: "cloudresourcemanagerProjectsUndelete", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{projectId}:undelete",
    validator: validate_CloudresourcemanagerProjectsUndelete_598137, base: "/",
    url: url_CloudresourcemanagerProjectsUndelete_598138, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsGetIamPolicy_598157 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerProjectsGetIamPolicy_598159(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsGetIamPolicy_598158(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the IAM access control policy for the specified Project.
  ## Permission is denied if the policy or the resource does not exist.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.getIamPolicy` on the project.
  ## 
  ## For additional information about resource structure and identification,
  ## see [Resource Names](/apis/design/resource_names).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598160 = path.getOrDefault("resource")
  valid_598160 = validateParameter(valid_598160, JString, required = true,
                                 default = nil)
  if valid_598160 != nil:
    section.add "resource", valid_598160
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
  var valid_598161 = query.getOrDefault("upload_protocol")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = nil)
  if valid_598161 != nil:
    section.add "upload_protocol", valid_598161
  var valid_598162 = query.getOrDefault("fields")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = nil)
  if valid_598162 != nil:
    section.add "fields", valid_598162
  var valid_598163 = query.getOrDefault("quotaUser")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = nil)
  if valid_598163 != nil:
    section.add "quotaUser", valid_598163
  var valid_598164 = query.getOrDefault("alt")
  valid_598164 = validateParameter(valid_598164, JString, required = false,
                                 default = newJString("json"))
  if valid_598164 != nil:
    section.add "alt", valid_598164
  var valid_598165 = query.getOrDefault("oauth_token")
  valid_598165 = validateParameter(valid_598165, JString, required = false,
                                 default = nil)
  if valid_598165 != nil:
    section.add "oauth_token", valid_598165
  var valid_598166 = query.getOrDefault("callback")
  valid_598166 = validateParameter(valid_598166, JString, required = false,
                                 default = nil)
  if valid_598166 != nil:
    section.add "callback", valid_598166
  var valid_598167 = query.getOrDefault("access_token")
  valid_598167 = validateParameter(valid_598167, JString, required = false,
                                 default = nil)
  if valid_598167 != nil:
    section.add "access_token", valid_598167
  var valid_598168 = query.getOrDefault("uploadType")
  valid_598168 = validateParameter(valid_598168, JString, required = false,
                                 default = nil)
  if valid_598168 != nil:
    section.add "uploadType", valid_598168
  var valid_598169 = query.getOrDefault("key")
  valid_598169 = validateParameter(valid_598169, JString, required = false,
                                 default = nil)
  if valid_598169 != nil:
    section.add "key", valid_598169
  var valid_598170 = query.getOrDefault("$.xgafv")
  valid_598170 = validateParameter(valid_598170, JString, required = false,
                                 default = newJString("1"))
  if valid_598170 != nil:
    section.add "$.xgafv", valid_598170
  var valid_598171 = query.getOrDefault("prettyPrint")
  valid_598171 = validateParameter(valid_598171, JBool, required = false,
                                 default = newJBool(true))
  if valid_598171 != nil:
    section.add "prettyPrint", valid_598171
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

proc call*(call_598173: Call_CloudresourcemanagerProjectsGetIamPolicy_598157;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the IAM access control policy for the specified Project.
  ## Permission is denied if the policy or the resource does not exist.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.getIamPolicy` on the project.
  ## 
  ## For additional information about resource structure and identification,
  ## see [Resource Names](/apis/design/resource_names).
  ## 
  let valid = call_598173.validator(path, query, header, formData, body)
  let scheme = call_598173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598173.url(scheme.get, call_598173.host, call_598173.base,
                         call_598173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598173, url, valid)

proc call*(call_598174: Call_CloudresourcemanagerProjectsGetIamPolicy_598157;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsGetIamPolicy
  ## Returns the IAM access control policy for the specified Project.
  ## Permission is denied if the policy or the resource does not exist.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.getIamPolicy` on the project.
  ## 
  ## For additional information about resource structure and identification,
  ## see [Resource Names](/apis/design/resource_names).
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598175 = newJObject()
  var query_598176 = newJObject()
  var body_598177 = newJObject()
  add(query_598176, "upload_protocol", newJString(uploadProtocol))
  add(query_598176, "fields", newJString(fields))
  add(query_598176, "quotaUser", newJString(quotaUser))
  add(query_598176, "alt", newJString(alt))
  add(query_598176, "oauth_token", newJString(oauthToken))
  add(query_598176, "callback", newJString(callback))
  add(query_598176, "access_token", newJString(accessToken))
  add(query_598176, "uploadType", newJString(uploadType))
  add(query_598176, "key", newJString(key))
  add(query_598176, "$.xgafv", newJString(Xgafv))
  add(path_598175, "resource", newJString(resource))
  if body != nil:
    body_598177 = body
  add(query_598176, "prettyPrint", newJBool(prettyPrint))
  result = call_598174.call(path_598175, query_598176, nil, nil, body_598177)

var cloudresourcemanagerProjectsGetIamPolicy* = Call_CloudresourcemanagerProjectsGetIamPolicy_598157(
    name: "cloudresourcemanagerProjectsGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{resource}:getIamPolicy",
    validator: validate_CloudresourcemanagerProjectsGetIamPolicy_598158,
    base: "/", url: url_CloudresourcemanagerProjectsGetIamPolicy_598159,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsSetIamPolicy_598178 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerProjectsSetIamPolicy_598180(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsSetIamPolicy_598179(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the IAM access control policy for the specified Project. Overwrites
  ## any existing policy.
  ## 
  ## The following constraints apply when using `setIamPolicy()`:
  ## 
  ## + Project does not support `allUsers` and `allAuthenticatedUsers` as
  ## `members` in a `Binding` of a `Policy`.
  ## 
  ## + The owner role can be granted to a `user`, `serviceAccount`, or a group
  ## that is part of an organization. For example,
  ## group@myownpersonaldomain.com could be added as an owner to a project in
  ## the myownpersonaldomain.com organization, but not the examplepetstore.com
  ## organization.
  ## 
  ## + Service accounts can be made owners of a project directly
  ## without any restrictions. However, to be added as an owner, a user must be
  ## invited via Cloud Platform console and must accept the invitation.
  ## 
  ## + A user cannot be granted the owner role using `setIamPolicy()`. The user
  ## must be granted the owner role using the Cloud Platform Console and must
  ## explicitly accept the invitation.
  ## 
  ## + You can only grant ownership of a project to a member by using the
  ## GCP Console. Inviting a member will deliver an invitation email that
  ## they must accept. An invitation email is not generated if you are
  ## granting a role other than owner, or if both the member you are inviting
  ## and the project are part of your organization.
  ## 
  ## + Membership changes that leave the project without any owners that have
  ## accepted the Terms of Service (ToS) will be rejected.
  ## 
  ## + If the project is not part of an organization, there must be at least
  ## one owner who has accepted the Terms of Service (ToS) agreement in the
  ## policy. Calling `setIamPolicy()` to remove the last ToS-accepted owner
  ## from the policy will fail. This restriction also applies to legacy
  ## projects that no longer have owners who have accepted the ToS. Edits to
  ## IAM policies will be rejected until the lack of a ToS-accepting owner is
  ## rectified.
  ## 
  ## + This method will replace the existing policy, and cannot be used to
  ## append additional IAM settings.
  ## 
  ## Note: Removing service accounts from policies or changing their roles
  ## can render services completely inoperable. It is important to understand
  ## how the service account is being used before removing or updating its
  ## roles.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.setIamPolicy` on the project
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598181 = path.getOrDefault("resource")
  valid_598181 = validateParameter(valid_598181, JString, required = true,
                                 default = nil)
  if valid_598181 != nil:
    section.add "resource", valid_598181
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
  var valid_598182 = query.getOrDefault("upload_protocol")
  valid_598182 = validateParameter(valid_598182, JString, required = false,
                                 default = nil)
  if valid_598182 != nil:
    section.add "upload_protocol", valid_598182
  var valid_598183 = query.getOrDefault("fields")
  valid_598183 = validateParameter(valid_598183, JString, required = false,
                                 default = nil)
  if valid_598183 != nil:
    section.add "fields", valid_598183
  var valid_598184 = query.getOrDefault("quotaUser")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = nil)
  if valid_598184 != nil:
    section.add "quotaUser", valid_598184
  var valid_598185 = query.getOrDefault("alt")
  valid_598185 = validateParameter(valid_598185, JString, required = false,
                                 default = newJString("json"))
  if valid_598185 != nil:
    section.add "alt", valid_598185
  var valid_598186 = query.getOrDefault("oauth_token")
  valid_598186 = validateParameter(valid_598186, JString, required = false,
                                 default = nil)
  if valid_598186 != nil:
    section.add "oauth_token", valid_598186
  var valid_598187 = query.getOrDefault("callback")
  valid_598187 = validateParameter(valid_598187, JString, required = false,
                                 default = nil)
  if valid_598187 != nil:
    section.add "callback", valid_598187
  var valid_598188 = query.getOrDefault("access_token")
  valid_598188 = validateParameter(valid_598188, JString, required = false,
                                 default = nil)
  if valid_598188 != nil:
    section.add "access_token", valid_598188
  var valid_598189 = query.getOrDefault("uploadType")
  valid_598189 = validateParameter(valid_598189, JString, required = false,
                                 default = nil)
  if valid_598189 != nil:
    section.add "uploadType", valid_598189
  var valid_598190 = query.getOrDefault("key")
  valid_598190 = validateParameter(valid_598190, JString, required = false,
                                 default = nil)
  if valid_598190 != nil:
    section.add "key", valid_598190
  var valid_598191 = query.getOrDefault("$.xgafv")
  valid_598191 = validateParameter(valid_598191, JString, required = false,
                                 default = newJString("1"))
  if valid_598191 != nil:
    section.add "$.xgafv", valid_598191
  var valid_598192 = query.getOrDefault("prettyPrint")
  valid_598192 = validateParameter(valid_598192, JBool, required = false,
                                 default = newJBool(true))
  if valid_598192 != nil:
    section.add "prettyPrint", valid_598192
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

proc call*(call_598194: Call_CloudresourcemanagerProjectsSetIamPolicy_598178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM access control policy for the specified Project. Overwrites
  ## any existing policy.
  ## 
  ## The following constraints apply when using `setIamPolicy()`:
  ## 
  ## + Project does not support `allUsers` and `allAuthenticatedUsers` as
  ## `members` in a `Binding` of a `Policy`.
  ## 
  ## + The owner role can be granted to a `user`, `serviceAccount`, or a group
  ## that is part of an organization. For example,
  ## group@myownpersonaldomain.com could be added as an owner to a project in
  ## the myownpersonaldomain.com organization, but not the examplepetstore.com
  ## organization.
  ## 
  ## + Service accounts can be made owners of a project directly
  ## without any restrictions. However, to be added as an owner, a user must be
  ## invited via Cloud Platform console and must accept the invitation.
  ## 
  ## + A user cannot be granted the owner role using `setIamPolicy()`. The user
  ## must be granted the owner role using the Cloud Platform Console and must
  ## explicitly accept the invitation.
  ## 
  ## + You can only grant ownership of a project to a member by using the
  ## GCP Console. Inviting a member will deliver an invitation email that
  ## they must accept. An invitation email is not generated if you are
  ## granting a role other than owner, or if both the member you are inviting
  ## and the project are part of your organization.
  ## 
  ## + Membership changes that leave the project without any owners that have
  ## accepted the Terms of Service (ToS) will be rejected.
  ## 
  ## + If the project is not part of an organization, there must be at least
  ## one owner who has accepted the Terms of Service (ToS) agreement in the
  ## policy. Calling `setIamPolicy()` to remove the last ToS-accepted owner
  ## from the policy will fail. This restriction also applies to legacy
  ## projects that no longer have owners who have accepted the ToS. Edits to
  ## IAM policies will be rejected until the lack of a ToS-accepting owner is
  ## rectified.
  ## 
  ## + This method will replace the existing policy, and cannot be used to
  ## append additional IAM settings.
  ## 
  ## Note: Removing service accounts from policies or changing their roles
  ## can render services completely inoperable. It is important to understand
  ## how the service account is being used before removing or updating its
  ## roles.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.setIamPolicy` on the project
  ## 
  let valid = call_598194.validator(path, query, header, formData, body)
  let scheme = call_598194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598194.url(scheme.get, call_598194.host, call_598194.base,
                         call_598194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598194, url, valid)

proc call*(call_598195: Call_CloudresourcemanagerProjectsSetIamPolicy_598178;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsSetIamPolicy
  ## Sets the IAM access control policy for the specified Project. Overwrites
  ## any existing policy.
  ## 
  ## The following constraints apply when using `setIamPolicy()`:
  ## 
  ## + Project does not support `allUsers` and `allAuthenticatedUsers` as
  ## `members` in a `Binding` of a `Policy`.
  ## 
  ## + The owner role can be granted to a `user`, `serviceAccount`, or a group
  ## that is part of an organization. For example,
  ## group@myownpersonaldomain.com could be added as an owner to a project in
  ## the myownpersonaldomain.com organization, but not the examplepetstore.com
  ## organization.
  ## 
  ## + Service accounts can be made owners of a project directly
  ## without any restrictions. However, to be added as an owner, a user must be
  ## invited via Cloud Platform console and must accept the invitation.
  ## 
  ## + A user cannot be granted the owner role using `setIamPolicy()`. The user
  ## must be granted the owner role using the Cloud Platform Console and must
  ## explicitly accept the invitation.
  ## 
  ## + You can only grant ownership of a project to a member by using the
  ## GCP Console. Inviting a member will deliver an invitation email that
  ## they must accept. An invitation email is not generated if you are
  ## granting a role other than owner, or if both the member you are inviting
  ## and the project are part of your organization.
  ## 
  ## + Membership changes that leave the project without any owners that have
  ## accepted the Terms of Service (ToS) will be rejected.
  ## 
  ## + If the project is not part of an organization, there must be at least
  ## one owner who has accepted the Terms of Service (ToS) agreement in the
  ## policy. Calling `setIamPolicy()` to remove the last ToS-accepted owner
  ## from the policy will fail. This restriction also applies to legacy
  ## projects that no longer have owners who have accepted the ToS. Edits to
  ## IAM policies will be rejected until the lack of a ToS-accepting owner is
  ## rectified.
  ## 
  ## + This method will replace the existing policy, and cannot be used to
  ## append additional IAM settings.
  ## 
  ## Note: Removing service accounts from policies or changing their roles
  ## can render services completely inoperable. It is important to understand
  ## how the service account is being used before removing or updating its
  ## roles.
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.projects.setIamPolicy` on the project
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598196 = newJObject()
  var query_598197 = newJObject()
  var body_598198 = newJObject()
  add(query_598197, "upload_protocol", newJString(uploadProtocol))
  add(query_598197, "fields", newJString(fields))
  add(query_598197, "quotaUser", newJString(quotaUser))
  add(query_598197, "alt", newJString(alt))
  add(query_598197, "oauth_token", newJString(oauthToken))
  add(query_598197, "callback", newJString(callback))
  add(query_598197, "access_token", newJString(accessToken))
  add(query_598197, "uploadType", newJString(uploadType))
  add(query_598197, "key", newJString(key))
  add(query_598197, "$.xgafv", newJString(Xgafv))
  add(path_598196, "resource", newJString(resource))
  if body != nil:
    body_598198 = body
  add(query_598197, "prettyPrint", newJBool(prettyPrint))
  result = call_598195.call(path_598196, query_598197, nil, nil, body_598198)

var cloudresourcemanagerProjectsSetIamPolicy* = Call_CloudresourcemanagerProjectsSetIamPolicy_598178(
    name: "cloudresourcemanagerProjectsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{resource}:setIamPolicy",
    validator: validate_CloudresourcemanagerProjectsSetIamPolicy_598179,
    base: "/", url: url_CloudresourcemanagerProjectsSetIamPolicy_598180,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsTestIamPermissions_598199 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerProjectsTestIamPermissions_598201(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsTestIamPermissions_598200(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598202 = path.getOrDefault("resource")
  valid_598202 = validateParameter(valid_598202, JString, required = true,
                                 default = nil)
  if valid_598202 != nil:
    section.add "resource", valid_598202
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
  var valid_598203 = query.getOrDefault("upload_protocol")
  valid_598203 = validateParameter(valid_598203, JString, required = false,
                                 default = nil)
  if valid_598203 != nil:
    section.add "upload_protocol", valid_598203
  var valid_598204 = query.getOrDefault("fields")
  valid_598204 = validateParameter(valid_598204, JString, required = false,
                                 default = nil)
  if valid_598204 != nil:
    section.add "fields", valid_598204
  var valid_598205 = query.getOrDefault("quotaUser")
  valid_598205 = validateParameter(valid_598205, JString, required = false,
                                 default = nil)
  if valid_598205 != nil:
    section.add "quotaUser", valid_598205
  var valid_598206 = query.getOrDefault("alt")
  valid_598206 = validateParameter(valid_598206, JString, required = false,
                                 default = newJString("json"))
  if valid_598206 != nil:
    section.add "alt", valid_598206
  var valid_598207 = query.getOrDefault("oauth_token")
  valid_598207 = validateParameter(valid_598207, JString, required = false,
                                 default = nil)
  if valid_598207 != nil:
    section.add "oauth_token", valid_598207
  var valid_598208 = query.getOrDefault("callback")
  valid_598208 = validateParameter(valid_598208, JString, required = false,
                                 default = nil)
  if valid_598208 != nil:
    section.add "callback", valid_598208
  var valid_598209 = query.getOrDefault("access_token")
  valid_598209 = validateParameter(valid_598209, JString, required = false,
                                 default = nil)
  if valid_598209 != nil:
    section.add "access_token", valid_598209
  var valid_598210 = query.getOrDefault("uploadType")
  valid_598210 = validateParameter(valid_598210, JString, required = false,
                                 default = nil)
  if valid_598210 != nil:
    section.add "uploadType", valid_598210
  var valid_598211 = query.getOrDefault("key")
  valid_598211 = validateParameter(valid_598211, JString, required = false,
                                 default = nil)
  if valid_598211 != nil:
    section.add "key", valid_598211
  var valid_598212 = query.getOrDefault("$.xgafv")
  valid_598212 = validateParameter(valid_598212, JString, required = false,
                                 default = newJString("1"))
  if valid_598212 != nil:
    section.add "$.xgafv", valid_598212
  var valid_598213 = query.getOrDefault("prettyPrint")
  valid_598213 = validateParameter(valid_598213, JBool, required = false,
                                 default = newJBool(true))
  if valid_598213 != nil:
    section.add "prettyPrint", valid_598213
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

proc call*(call_598215: Call_CloudresourcemanagerProjectsTestIamPermissions_598199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_598215.validator(path, query, header, formData, body)
  let scheme = call_598215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598215.url(scheme.get, call_598215.host, call_598215.base,
                         call_598215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598215, url, valid)

proc call*(call_598216: Call_CloudresourcemanagerProjectsTestIamPermissions_598199;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerProjectsTestIamPermissions
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598217 = newJObject()
  var query_598218 = newJObject()
  var body_598219 = newJObject()
  add(query_598218, "upload_protocol", newJString(uploadProtocol))
  add(query_598218, "fields", newJString(fields))
  add(query_598218, "quotaUser", newJString(quotaUser))
  add(query_598218, "alt", newJString(alt))
  add(query_598218, "oauth_token", newJString(oauthToken))
  add(query_598218, "callback", newJString(callback))
  add(query_598218, "access_token", newJString(accessToken))
  add(query_598218, "uploadType", newJString(uploadType))
  add(query_598218, "key", newJString(key))
  add(query_598218, "$.xgafv", newJString(Xgafv))
  add(path_598217, "resource", newJString(resource))
  if body != nil:
    body_598219 = body
  add(query_598218, "prettyPrint", newJBool(prettyPrint))
  result = call_598216.call(path_598217, query_598218, nil, nil, body_598219)

var cloudresourcemanagerProjectsTestIamPermissions* = Call_CloudresourcemanagerProjectsTestIamPermissions_598199(
    name: "cloudresourcemanagerProjectsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{resource}:testIamPermissions",
    validator: validate_CloudresourcemanagerProjectsTestIamPermissions_598200,
    base: "/", url: url_CloudresourcemanagerProjectsTestIamPermissions_598201,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsGet_598220 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerOrganizationsGet_598222(protocol: Scheme;
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

proc validate_CloudresourcemanagerOrganizationsGet_598221(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetches an Organization resource identified by the specified resource name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the Organization to fetch. This is the organization's
  ## relative path in the API, formatted as "organizations/[organizationId]".
  ## For example, "organizations/1234".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_598223 = path.getOrDefault("name")
  valid_598223 = validateParameter(valid_598223, JString, required = true,
                                 default = nil)
  if valid_598223 != nil:
    section.add "name", valid_598223
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
  var valid_598224 = query.getOrDefault("upload_protocol")
  valid_598224 = validateParameter(valid_598224, JString, required = false,
                                 default = nil)
  if valid_598224 != nil:
    section.add "upload_protocol", valid_598224
  var valid_598225 = query.getOrDefault("fields")
  valid_598225 = validateParameter(valid_598225, JString, required = false,
                                 default = nil)
  if valid_598225 != nil:
    section.add "fields", valid_598225
  var valid_598226 = query.getOrDefault("quotaUser")
  valid_598226 = validateParameter(valid_598226, JString, required = false,
                                 default = nil)
  if valid_598226 != nil:
    section.add "quotaUser", valid_598226
  var valid_598227 = query.getOrDefault("alt")
  valid_598227 = validateParameter(valid_598227, JString, required = false,
                                 default = newJString("json"))
  if valid_598227 != nil:
    section.add "alt", valid_598227
  var valid_598228 = query.getOrDefault("oauth_token")
  valid_598228 = validateParameter(valid_598228, JString, required = false,
                                 default = nil)
  if valid_598228 != nil:
    section.add "oauth_token", valid_598228
  var valid_598229 = query.getOrDefault("callback")
  valid_598229 = validateParameter(valid_598229, JString, required = false,
                                 default = nil)
  if valid_598229 != nil:
    section.add "callback", valid_598229
  var valid_598230 = query.getOrDefault("access_token")
  valid_598230 = validateParameter(valid_598230, JString, required = false,
                                 default = nil)
  if valid_598230 != nil:
    section.add "access_token", valid_598230
  var valid_598231 = query.getOrDefault("uploadType")
  valid_598231 = validateParameter(valid_598231, JString, required = false,
                                 default = nil)
  if valid_598231 != nil:
    section.add "uploadType", valid_598231
  var valid_598232 = query.getOrDefault("key")
  valid_598232 = validateParameter(valid_598232, JString, required = false,
                                 default = nil)
  if valid_598232 != nil:
    section.add "key", valid_598232
  var valid_598233 = query.getOrDefault("$.xgafv")
  valid_598233 = validateParameter(valid_598233, JString, required = false,
                                 default = newJString("1"))
  if valid_598233 != nil:
    section.add "$.xgafv", valid_598233
  var valid_598234 = query.getOrDefault("prettyPrint")
  valid_598234 = validateParameter(valid_598234, JBool, required = false,
                                 default = newJBool(true))
  if valid_598234 != nil:
    section.add "prettyPrint", valid_598234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598235: Call_CloudresourcemanagerOrganizationsGet_598220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches an Organization resource identified by the specified resource name.
  ## 
  let valid = call_598235.validator(path, query, header, formData, body)
  let scheme = call_598235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598235.url(scheme.get, call_598235.host, call_598235.base,
                         call_598235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598235, url, valid)

proc call*(call_598236: Call_CloudresourcemanagerOrganizationsGet_598220;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsGet
  ## Fetches an Organization resource identified by the specified resource name.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the Organization to fetch. This is the organization's
  ## relative path in the API, formatted as "organizations/[organizationId]".
  ## For example, "organizations/1234".
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
  var path_598237 = newJObject()
  var query_598238 = newJObject()
  add(query_598238, "upload_protocol", newJString(uploadProtocol))
  add(query_598238, "fields", newJString(fields))
  add(query_598238, "quotaUser", newJString(quotaUser))
  add(path_598237, "name", newJString(name))
  add(query_598238, "alt", newJString(alt))
  add(query_598238, "oauth_token", newJString(oauthToken))
  add(query_598238, "callback", newJString(callback))
  add(query_598238, "access_token", newJString(accessToken))
  add(query_598238, "uploadType", newJString(uploadType))
  add(query_598238, "key", newJString(key))
  add(query_598238, "$.xgafv", newJString(Xgafv))
  add(query_598238, "prettyPrint", newJBool(prettyPrint))
  result = call_598236.call(path_598237, query_598238, nil, nil, nil)

var cloudresourcemanagerOrganizationsGet* = Call_CloudresourcemanagerOrganizationsGet_598220(
    name: "cloudresourcemanagerOrganizationsGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudresourcemanagerOrganizationsGet_598221, base: "/",
    url: url_CloudresourcemanagerOrganizationsGet_598222, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerLiensDelete_598239 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerLiensDelete_598241(protocol: Scheme; host: string;
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

proc validate_CloudresourcemanagerLiensDelete_598240(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Lien by `name`.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, a Lien with a `parent` of `projects/1234` requires permission
  ## `resourcemanager.projects.updateLiens`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name/identifier of the Lien to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_598242 = path.getOrDefault("name")
  valid_598242 = validateParameter(valid_598242, JString, required = true,
                                 default = nil)
  if valid_598242 != nil:
    section.add "name", valid_598242
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
  var valid_598243 = query.getOrDefault("upload_protocol")
  valid_598243 = validateParameter(valid_598243, JString, required = false,
                                 default = nil)
  if valid_598243 != nil:
    section.add "upload_protocol", valid_598243
  var valid_598244 = query.getOrDefault("fields")
  valid_598244 = validateParameter(valid_598244, JString, required = false,
                                 default = nil)
  if valid_598244 != nil:
    section.add "fields", valid_598244
  var valid_598245 = query.getOrDefault("quotaUser")
  valid_598245 = validateParameter(valid_598245, JString, required = false,
                                 default = nil)
  if valid_598245 != nil:
    section.add "quotaUser", valid_598245
  var valid_598246 = query.getOrDefault("alt")
  valid_598246 = validateParameter(valid_598246, JString, required = false,
                                 default = newJString("json"))
  if valid_598246 != nil:
    section.add "alt", valid_598246
  var valid_598247 = query.getOrDefault("oauth_token")
  valid_598247 = validateParameter(valid_598247, JString, required = false,
                                 default = nil)
  if valid_598247 != nil:
    section.add "oauth_token", valid_598247
  var valid_598248 = query.getOrDefault("callback")
  valid_598248 = validateParameter(valid_598248, JString, required = false,
                                 default = nil)
  if valid_598248 != nil:
    section.add "callback", valid_598248
  var valid_598249 = query.getOrDefault("access_token")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = nil)
  if valid_598249 != nil:
    section.add "access_token", valid_598249
  var valid_598250 = query.getOrDefault("uploadType")
  valid_598250 = validateParameter(valid_598250, JString, required = false,
                                 default = nil)
  if valid_598250 != nil:
    section.add "uploadType", valid_598250
  var valid_598251 = query.getOrDefault("key")
  valid_598251 = validateParameter(valid_598251, JString, required = false,
                                 default = nil)
  if valid_598251 != nil:
    section.add "key", valid_598251
  var valid_598252 = query.getOrDefault("$.xgafv")
  valid_598252 = validateParameter(valid_598252, JString, required = false,
                                 default = newJString("1"))
  if valid_598252 != nil:
    section.add "$.xgafv", valid_598252
  var valid_598253 = query.getOrDefault("prettyPrint")
  valid_598253 = validateParameter(valid_598253, JBool, required = false,
                                 default = newJBool(true))
  if valid_598253 != nil:
    section.add "prettyPrint", valid_598253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598254: Call_CloudresourcemanagerLiensDelete_598239;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a Lien by `name`.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, a Lien with a `parent` of `projects/1234` requires permission
  ## `resourcemanager.projects.updateLiens`.
  ## 
  let valid = call_598254.validator(path, query, header, formData, body)
  let scheme = call_598254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598254.url(scheme.get, call_598254.host, call_598254.base,
                         call_598254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598254, url, valid)

proc call*(call_598255: Call_CloudresourcemanagerLiensDelete_598239; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerLiensDelete
  ## Delete a Lien by `name`.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, a Lien with a `parent` of `projects/1234` requires permission
  ## `resourcemanager.projects.updateLiens`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name/identifier of the Lien to delete.
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
  var path_598256 = newJObject()
  var query_598257 = newJObject()
  add(query_598257, "upload_protocol", newJString(uploadProtocol))
  add(query_598257, "fields", newJString(fields))
  add(query_598257, "quotaUser", newJString(quotaUser))
  add(path_598256, "name", newJString(name))
  add(query_598257, "alt", newJString(alt))
  add(query_598257, "oauth_token", newJString(oauthToken))
  add(query_598257, "callback", newJString(callback))
  add(query_598257, "access_token", newJString(accessToken))
  add(query_598257, "uploadType", newJString(uploadType))
  add(query_598257, "key", newJString(key))
  add(query_598257, "$.xgafv", newJString(Xgafv))
  add(query_598257, "prettyPrint", newJBool(prettyPrint))
  result = call_598255.call(path_598256, query_598257, nil, nil, nil)

var cloudresourcemanagerLiensDelete* = Call_CloudresourcemanagerLiensDelete_598239(
    name: "cloudresourcemanagerLiensDelete", meth: HttpMethod.HttpDelete,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudresourcemanagerLiensDelete_598240, base: "/",
    url: url_CloudresourcemanagerLiensDelete_598241, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsClearOrgPolicy_598258 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerOrganizationsClearOrgPolicy_598260(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":clearOrgPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsClearOrgPolicy_598259(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Clears a `Policy` from a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name of the resource for the `Policy` to clear.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598261 = path.getOrDefault("resource")
  valid_598261 = validateParameter(valid_598261, JString, required = true,
                                 default = nil)
  if valid_598261 != nil:
    section.add "resource", valid_598261
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
  var valid_598262 = query.getOrDefault("upload_protocol")
  valid_598262 = validateParameter(valid_598262, JString, required = false,
                                 default = nil)
  if valid_598262 != nil:
    section.add "upload_protocol", valid_598262
  var valid_598263 = query.getOrDefault("fields")
  valid_598263 = validateParameter(valid_598263, JString, required = false,
                                 default = nil)
  if valid_598263 != nil:
    section.add "fields", valid_598263
  var valid_598264 = query.getOrDefault("quotaUser")
  valid_598264 = validateParameter(valid_598264, JString, required = false,
                                 default = nil)
  if valid_598264 != nil:
    section.add "quotaUser", valid_598264
  var valid_598265 = query.getOrDefault("alt")
  valid_598265 = validateParameter(valid_598265, JString, required = false,
                                 default = newJString("json"))
  if valid_598265 != nil:
    section.add "alt", valid_598265
  var valid_598266 = query.getOrDefault("oauth_token")
  valid_598266 = validateParameter(valid_598266, JString, required = false,
                                 default = nil)
  if valid_598266 != nil:
    section.add "oauth_token", valid_598266
  var valid_598267 = query.getOrDefault("callback")
  valid_598267 = validateParameter(valid_598267, JString, required = false,
                                 default = nil)
  if valid_598267 != nil:
    section.add "callback", valid_598267
  var valid_598268 = query.getOrDefault("access_token")
  valid_598268 = validateParameter(valid_598268, JString, required = false,
                                 default = nil)
  if valid_598268 != nil:
    section.add "access_token", valid_598268
  var valid_598269 = query.getOrDefault("uploadType")
  valid_598269 = validateParameter(valid_598269, JString, required = false,
                                 default = nil)
  if valid_598269 != nil:
    section.add "uploadType", valid_598269
  var valid_598270 = query.getOrDefault("key")
  valid_598270 = validateParameter(valid_598270, JString, required = false,
                                 default = nil)
  if valid_598270 != nil:
    section.add "key", valid_598270
  var valid_598271 = query.getOrDefault("$.xgafv")
  valid_598271 = validateParameter(valid_598271, JString, required = false,
                                 default = newJString("1"))
  if valid_598271 != nil:
    section.add "$.xgafv", valid_598271
  var valid_598272 = query.getOrDefault("prettyPrint")
  valid_598272 = validateParameter(valid_598272, JBool, required = false,
                                 default = newJBool(true))
  if valid_598272 != nil:
    section.add "prettyPrint", valid_598272
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

proc call*(call_598274: Call_CloudresourcemanagerOrganizationsClearOrgPolicy_598258;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Clears a `Policy` from a resource.
  ## 
  let valid = call_598274.validator(path, query, header, formData, body)
  let scheme = call_598274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598274.url(scheme.get, call_598274.host, call_598274.base,
                         call_598274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598274, url, valid)

proc call*(call_598275: Call_CloudresourcemanagerOrganizationsClearOrgPolicy_598258;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsClearOrgPolicy
  ## Clears a `Policy` from a resource.
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
  ##   resource: string (required)
  ##           : Name of the resource for the `Policy` to clear.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598276 = newJObject()
  var query_598277 = newJObject()
  var body_598278 = newJObject()
  add(query_598277, "upload_protocol", newJString(uploadProtocol))
  add(query_598277, "fields", newJString(fields))
  add(query_598277, "quotaUser", newJString(quotaUser))
  add(query_598277, "alt", newJString(alt))
  add(query_598277, "oauth_token", newJString(oauthToken))
  add(query_598277, "callback", newJString(callback))
  add(query_598277, "access_token", newJString(accessToken))
  add(query_598277, "uploadType", newJString(uploadType))
  add(query_598277, "key", newJString(key))
  add(query_598277, "$.xgafv", newJString(Xgafv))
  add(path_598276, "resource", newJString(resource))
  if body != nil:
    body_598278 = body
  add(query_598277, "prettyPrint", newJBool(prettyPrint))
  result = call_598275.call(path_598276, query_598277, nil, nil, body_598278)

var cloudresourcemanagerOrganizationsClearOrgPolicy* = Call_CloudresourcemanagerOrganizationsClearOrgPolicy_598258(
    name: "cloudresourcemanagerOrganizationsClearOrgPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:clearOrgPolicy",
    validator: validate_CloudresourcemanagerOrganizationsClearOrgPolicy_598259,
    base: "/", url: url_CloudresourcemanagerOrganizationsClearOrgPolicy_598260,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_598279 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_598281(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getEffectiveOrgPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_598280(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the effective `Policy` on a resource. This is the result of merging
  ## `Policies` in the resource hierarchy. The returned `Policy` will not have
  ## an `etag`set because it is a computed `Policy` across multiple resources.
  ## Subtrees of Resource Manager resource hierarchy with 'under:' prefix will
  ## not be expanded.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : The name of the resource to start computing the effective `Policy`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598282 = path.getOrDefault("resource")
  valid_598282 = validateParameter(valid_598282, JString, required = true,
                                 default = nil)
  if valid_598282 != nil:
    section.add "resource", valid_598282
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
  var valid_598283 = query.getOrDefault("upload_protocol")
  valid_598283 = validateParameter(valid_598283, JString, required = false,
                                 default = nil)
  if valid_598283 != nil:
    section.add "upload_protocol", valid_598283
  var valid_598284 = query.getOrDefault("fields")
  valid_598284 = validateParameter(valid_598284, JString, required = false,
                                 default = nil)
  if valid_598284 != nil:
    section.add "fields", valid_598284
  var valid_598285 = query.getOrDefault("quotaUser")
  valid_598285 = validateParameter(valid_598285, JString, required = false,
                                 default = nil)
  if valid_598285 != nil:
    section.add "quotaUser", valid_598285
  var valid_598286 = query.getOrDefault("alt")
  valid_598286 = validateParameter(valid_598286, JString, required = false,
                                 default = newJString("json"))
  if valid_598286 != nil:
    section.add "alt", valid_598286
  var valid_598287 = query.getOrDefault("oauth_token")
  valid_598287 = validateParameter(valid_598287, JString, required = false,
                                 default = nil)
  if valid_598287 != nil:
    section.add "oauth_token", valid_598287
  var valid_598288 = query.getOrDefault("callback")
  valid_598288 = validateParameter(valid_598288, JString, required = false,
                                 default = nil)
  if valid_598288 != nil:
    section.add "callback", valid_598288
  var valid_598289 = query.getOrDefault("access_token")
  valid_598289 = validateParameter(valid_598289, JString, required = false,
                                 default = nil)
  if valid_598289 != nil:
    section.add "access_token", valid_598289
  var valid_598290 = query.getOrDefault("uploadType")
  valid_598290 = validateParameter(valid_598290, JString, required = false,
                                 default = nil)
  if valid_598290 != nil:
    section.add "uploadType", valid_598290
  var valid_598291 = query.getOrDefault("key")
  valid_598291 = validateParameter(valid_598291, JString, required = false,
                                 default = nil)
  if valid_598291 != nil:
    section.add "key", valid_598291
  var valid_598292 = query.getOrDefault("$.xgafv")
  valid_598292 = validateParameter(valid_598292, JString, required = false,
                                 default = newJString("1"))
  if valid_598292 != nil:
    section.add "$.xgafv", valid_598292
  var valid_598293 = query.getOrDefault("prettyPrint")
  valid_598293 = validateParameter(valid_598293, JBool, required = false,
                                 default = newJBool(true))
  if valid_598293 != nil:
    section.add "prettyPrint", valid_598293
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

proc call*(call_598295: Call_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_598279;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the effective `Policy` on a resource. This is the result of merging
  ## `Policies` in the resource hierarchy. The returned `Policy` will not have
  ## an `etag`set because it is a computed `Policy` across multiple resources.
  ## Subtrees of Resource Manager resource hierarchy with 'under:' prefix will
  ## not be expanded.
  ## 
  let valid = call_598295.validator(path, query, header, formData, body)
  let scheme = call_598295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598295.url(scheme.get, call_598295.host, call_598295.base,
                         call_598295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598295, url, valid)

proc call*(call_598296: Call_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_598279;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsGetEffectiveOrgPolicy
  ## Gets the effective `Policy` on a resource. This is the result of merging
  ## `Policies` in the resource hierarchy. The returned `Policy` will not have
  ## an `etag`set because it is a computed `Policy` across multiple resources.
  ## Subtrees of Resource Manager resource hierarchy with 'under:' prefix will
  ## not be expanded.
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
  ##   resource: string (required)
  ##           : The name of the resource to start computing the effective `Policy`.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598297 = newJObject()
  var query_598298 = newJObject()
  var body_598299 = newJObject()
  add(query_598298, "upload_protocol", newJString(uploadProtocol))
  add(query_598298, "fields", newJString(fields))
  add(query_598298, "quotaUser", newJString(quotaUser))
  add(query_598298, "alt", newJString(alt))
  add(query_598298, "oauth_token", newJString(oauthToken))
  add(query_598298, "callback", newJString(callback))
  add(query_598298, "access_token", newJString(accessToken))
  add(query_598298, "uploadType", newJString(uploadType))
  add(query_598298, "key", newJString(key))
  add(query_598298, "$.xgafv", newJString(Xgafv))
  add(path_598297, "resource", newJString(resource))
  if body != nil:
    body_598299 = body
  add(query_598298, "prettyPrint", newJBool(prettyPrint))
  result = call_598296.call(path_598297, query_598298, nil, nil, body_598299)

var cloudresourcemanagerOrganizationsGetEffectiveOrgPolicy* = Call_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_598279(
    name: "cloudresourcemanagerOrganizationsGetEffectiveOrgPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:getEffectiveOrgPolicy",
    validator: validate_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_598280,
    base: "/", url: url_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_598281,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsGetIamPolicy_598300 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerOrganizationsGetIamPolicy_598302(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsGetIamPolicy_598301(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the access control policy for an Organization resource. May be empty
  ## if no such policy or resource exists. The `resource` field should be the
  ## organization's resource name, e.g. "organizations/123".
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.organizations.getIamPolicy` on the specified organization
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598303 = path.getOrDefault("resource")
  valid_598303 = validateParameter(valid_598303, JString, required = true,
                                 default = nil)
  if valid_598303 != nil:
    section.add "resource", valid_598303
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
  var valid_598304 = query.getOrDefault("upload_protocol")
  valid_598304 = validateParameter(valid_598304, JString, required = false,
                                 default = nil)
  if valid_598304 != nil:
    section.add "upload_protocol", valid_598304
  var valid_598305 = query.getOrDefault("fields")
  valid_598305 = validateParameter(valid_598305, JString, required = false,
                                 default = nil)
  if valid_598305 != nil:
    section.add "fields", valid_598305
  var valid_598306 = query.getOrDefault("quotaUser")
  valid_598306 = validateParameter(valid_598306, JString, required = false,
                                 default = nil)
  if valid_598306 != nil:
    section.add "quotaUser", valid_598306
  var valid_598307 = query.getOrDefault("alt")
  valid_598307 = validateParameter(valid_598307, JString, required = false,
                                 default = newJString("json"))
  if valid_598307 != nil:
    section.add "alt", valid_598307
  var valid_598308 = query.getOrDefault("oauth_token")
  valid_598308 = validateParameter(valid_598308, JString, required = false,
                                 default = nil)
  if valid_598308 != nil:
    section.add "oauth_token", valid_598308
  var valid_598309 = query.getOrDefault("callback")
  valid_598309 = validateParameter(valid_598309, JString, required = false,
                                 default = nil)
  if valid_598309 != nil:
    section.add "callback", valid_598309
  var valid_598310 = query.getOrDefault("access_token")
  valid_598310 = validateParameter(valid_598310, JString, required = false,
                                 default = nil)
  if valid_598310 != nil:
    section.add "access_token", valid_598310
  var valid_598311 = query.getOrDefault("uploadType")
  valid_598311 = validateParameter(valid_598311, JString, required = false,
                                 default = nil)
  if valid_598311 != nil:
    section.add "uploadType", valid_598311
  var valid_598312 = query.getOrDefault("key")
  valid_598312 = validateParameter(valid_598312, JString, required = false,
                                 default = nil)
  if valid_598312 != nil:
    section.add "key", valid_598312
  var valid_598313 = query.getOrDefault("$.xgafv")
  valid_598313 = validateParameter(valid_598313, JString, required = false,
                                 default = newJString("1"))
  if valid_598313 != nil:
    section.add "$.xgafv", valid_598313
  var valid_598314 = query.getOrDefault("prettyPrint")
  valid_598314 = validateParameter(valid_598314, JBool, required = false,
                                 default = newJBool(true))
  if valid_598314 != nil:
    section.add "prettyPrint", valid_598314
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

proc call*(call_598316: Call_CloudresourcemanagerOrganizationsGetIamPolicy_598300;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for an Organization resource. May be empty
  ## if no such policy or resource exists. The `resource` field should be the
  ## organization's resource name, e.g. "organizations/123".
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.organizations.getIamPolicy` on the specified organization
  ## 
  let valid = call_598316.validator(path, query, header, formData, body)
  let scheme = call_598316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598316.url(scheme.get, call_598316.host, call_598316.base,
                         call_598316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598316, url, valid)

proc call*(call_598317: Call_CloudresourcemanagerOrganizationsGetIamPolicy_598300;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsGetIamPolicy
  ## Gets the access control policy for an Organization resource. May be empty
  ## if no such policy or resource exists. The `resource` field should be the
  ## organization's resource name, e.g. "organizations/123".
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.organizations.getIamPolicy` on the specified organization
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598318 = newJObject()
  var query_598319 = newJObject()
  var body_598320 = newJObject()
  add(query_598319, "upload_protocol", newJString(uploadProtocol))
  add(query_598319, "fields", newJString(fields))
  add(query_598319, "quotaUser", newJString(quotaUser))
  add(query_598319, "alt", newJString(alt))
  add(query_598319, "oauth_token", newJString(oauthToken))
  add(query_598319, "callback", newJString(callback))
  add(query_598319, "access_token", newJString(accessToken))
  add(query_598319, "uploadType", newJString(uploadType))
  add(query_598319, "key", newJString(key))
  add(query_598319, "$.xgafv", newJString(Xgafv))
  add(path_598318, "resource", newJString(resource))
  if body != nil:
    body_598320 = body
  add(query_598319, "prettyPrint", newJBool(prettyPrint))
  result = call_598317.call(path_598318, query_598319, nil, nil, body_598320)

var cloudresourcemanagerOrganizationsGetIamPolicy* = Call_CloudresourcemanagerOrganizationsGetIamPolicy_598300(
    name: "cloudresourcemanagerOrganizationsGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_CloudresourcemanagerOrganizationsGetIamPolicy_598301,
    base: "/", url: url_CloudresourcemanagerOrganizationsGetIamPolicy_598302,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsGetOrgPolicy_598321 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerOrganizationsGetOrgPolicy_598323(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getOrgPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsGetOrgPolicy_598322(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a `Policy` on a resource.
  ## 
  ## If no `Policy` is set on the resource, a `Policy` is returned with default
  ## values including `POLICY_TYPE_NOT_SET` for the `policy_type oneof`. The
  ## `etag` value can be used with `SetOrgPolicy()` to create or update a
  ## `Policy` during read-modify-write.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name of the resource the `Policy` is set on.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598324 = path.getOrDefault("resource")
  valid_598324 = validateParameter(valid_598324, JString, required = true,
                                 default = nil)
  if valid_598324 != nil:
    section.add "resource", valid_598324
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
  var valid_598325 = query.getOrDefault("upload_protocol")
  valid_598325 = validateParameter(valid_598325, JString, required = false,
                                 default = nil)
  if valid_598325 != nil:
    section.add "upload_protocol", valid_598325
  var valid_598326 = query.getOrDefault("fields")
  valid_598326 = validateParameter(valid_598326, JString, required = false,
                                 default = nil)
  if valid_598326 != nil:
    section.add "fields", valid_598326
  var valid_598327 = query.getOrDefault("quotaUser")
  valid_598327 = validateParameter(valid_598327, JString, required = false,
                                 default = nil)
  if valid_598327 != nil:
    section.add "quotaUser", valid_598327
  var valid_598328 = query.getOrDefault("alt")
  valid_598328 = validateParameter(valid_598328, JString, required = false,
                                 default = newJString("json"))
  if valid_598328 != nil:
    section.add "alt", valid_598328
  var valid_598329 = query.getOrDefault("oauth_token")
  valid_598329 = validateParameter(valid_598329, JString, required = false,
                                 default = nil)
  if valid_598329 != nil:
    section.add "oauth_token", valid_598329
  var valid_598330 = query.getOrDefault("callback")
  valid_598330 = validateParameter(valid_598330, JString, required = false,
                                 default = nil)
  if valid_598330 != nil:
    section.add "callback", valid_598330
  var valid_598331 = query.getOrDefault("access_token")
  valid_598331 = validateParameter(valid_598331, JString, required = false,
                                 default = nil)
  if valid_598331 != nil:
    section.add "access_token", valid_598331
  var valid_598332 = query.getOrDefault("uploadType")
  valid_598332 = validateParameter(valid_598332, JString, required = false,
                                 default = nil)
  if valid_598332 != nil:
    section.add "uploadType", valid_598332
  var valid_598333 = query.getOrDefault("key")
  valid_598333 = validateParameter(valid_598333, JString, required = false,
                                 default = nil)
  if valid_598333 != nil:
    section.add "key", valid_598333
  var valid_598334 = query.getOrDefault("$.xgafv")
  valid_598334 = validateParameter(valid_598334, JString, required = false,
                                 default = newJString("1"))
  if valid_598334 != nil:
    section.add "$.xgafv", valid_598334
  var valid_598335 = query.getOrDefault("prettyPrint")
  valid_598335 = validateParameter(valid_598335, JBool, required = false,
                                 default = newJBool(true))
  if valid_598335 != nil:
    section.add "prettyPrint", valid_598335
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

proc call*(call_598337: Call_CloudresourcemanagerOrganizationsGetOrgPolicy_598321;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a `Policy` on a resource.
  ## 
  ## If no `Policy` is set on the resource, a `Policy` is returned with default
  ## values including `POLICY_TYPE_NOT_SET` for the `policy_type oneof`. The
  ## `etag` value can be used with `SetOrgPolicy()` to create or update a
  ## `Policy` during read-modify-write.
  ## 
  let valid = call_598337.validator(path, query, header, formData, body)
  let scheme = call_598337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598337.url(scheme.get, call_598337.host, call_598337.base,
                         call_598337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598337, url, valid)

proc call*(call_598338: Call_CloudresourcemanagerOrganizationsGetOrgPolicy_598321;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsGetOrgPolicy
  ## Gets a `Policy` on a resource.
  ## 
  ## If no `Policy` is set on the resource, a `Policy` is returned with default
  ## values including `POLICY_TYPE_NOT_SET` for the `policy_type oneof`. The
  ## `etag` value can be used with `SetOrgPolicy()` to create or update a
  ## `Policy` during read-modify-write.
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
  ##   resource: string (required)
  ##           : Name of the resource the `Policy` is set on.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598339 = newJObject()
  var query_598340 = newJObject()
  var body_598341 = newJObject()
  add(query_598340, "upload_protocol", newJString(uploadProtocol))
  add(query_598340, "fields", newJString(fields))
  add(query_598340, "quotaUser", newJString(quotaUser))
  add(query_598340, "alt", newJString(alt))
  add(query_598340, "oauth_token", newJString(oauthToken))
  add(query_598340, "callback", newJString(callback))
  add(query_598340, "access_token", newJString(accessToken))
  add(query_598340, "uploadType", newJString(uploadType))
  add(query_598340, "key", newJString(key))
  add(query_598340, "$.xgafv", newJString(Xgafv))
  add(path_598339, "resource", newJString(resource))
  if body != nil:
    body_598341 = body
  add(query_598340, "prettyPrint", newJBool(prettyPrint))
  result = call_598338.call(path_598339, query_598340, nil, nil, body_598341)

var cloudresourcemanagerOrganizationsGetOrgPolicy* = Call_CloudresourcemanagerOrganizationsGetOrgPolicy_598321(
    name: "cloudresourcemanagerOrganizationsGetOrgPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:getOrgPolicy",
    validator: validate_CloudresourcemanagerOrganizationsGetOrgPolicy_598322,
    base: "/", url: url_CloudresourcemanagerOrganizationsGetOrgPolicy_598323,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_598342 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_598344(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"), (kind: ConstantSegment,
        value: ":listAvailableOrgPolicyConstraints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_598343(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists `Constraints` that could be applied on the specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name of the resource to list `Constraints` for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598345 = path.getOrDefault("resource")
  valid_598345 = validateParameter(valid_598345, JString, required = true,
                                 default = nil)
  if valid_598345 != nil:
    section.add "resource", valid_598345
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
  var valid_598346 = query.getOrDefault("upload_protocol")
  valid_598346 = validateParameter(valid_598346, JString, required = false,
                                 default = nil)
  if valid_598346 != nil:
    section.add "upload_protocol", valid_598346
  var valid_598347 = query.getOrDefault("fields")
  valid_598347 = validateParameter(valid_598347, JString, required = false,
                                 default = nil)
  if valid_598347 != nil:
    section.add "fields", valid_598347
  var valid_598348 = query.getOrDefault("quotaUser")
  valid_598348 = validateParameter(valid_598348, JString, required = false,
                                 default = nil)
  if valid_598348 != nil:
    section.add "quotaUser", valid_598348
  var valid_598349 = query.getOrDefault("alt")
  valid_598349 = validateParameter(valid_598349, JString, required = false,
                                 default = newJString("json"))
  if valid_598349 != nil:
    section.add "alt", valid_598349
  var valid_598350 = query.getOrDefault("oauth_token")
  valid_598350 = validateParameter(valid_598350, JString, required = false,
                                 default = nil)
  if valid_598350 != nil:
    section.add "oauth_token", valid_598350
  var valid_598351 = query.getOrDefault("callback")
  valid_598351 = validateParameter(valid_598351, JString, required = false,
                                 default = nil)
  if valid_598351 != nil:
    section.add "callback", valid_598351
  var valid_598352 = query.getOrDefault("access_token")
  valid_598352 = validateParameter(valid_598352, JString, required = false,
                                 default = nil)
  if valid_598352 != nil:
    section.add "access_token", valid_598352
  var valid_598353 = query.getOrDefault("uploadType")
  valid_598353 = validateParameter(valid_598353, JString, required = false,
                                 default = nil)
  if valid_598353 != nil:
    section.add "uploadType", valid_598353
  var valid_598354 = query.getOrDefault("key")
  valid_598354 = validateParameter(valid_598354, JString, required = false,
                                 default = nil)
  if valid_598354 != nil:
    section.add "key", valid_598354
  var valid_598355 = query.getOrDefault("$.xgafv")
  valid_598355 = validateParameter(valid_598355, JString, required = false,
                                 default = newJString("1"))
  if valid_598355 != nil:
    section.add "$.xgafv", valid_598355
  var valid_598356 = query.getOrDefault("prettyPrint")
  valid_598356 = validateParameter(valid_598356, JBool, required = false,
                                 default = newJBool(true))
  if valid_598356 != nil:
    section.add "prettyPrint", valid_598356
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

proc call*(call_598358: Call_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_598342;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists `Constraints` that could be applied on the specified resource.
  ## 
  let valid = call_598358.validator(path, query, header, formData, body)
  let scheme = call_598358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598358.url(scheme.get, call_598358.host, call_598358.base,
                         call_598358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598358, url, valid)

proc call*(call_598359: Call_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_598342;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints
  ## Lists `Constraints` that could be applied on the specified resource.
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
  ##   resource: string (required)
  ##           : Name of the resource to list `Constraints` for.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598360 = newJObject()
  var query_598361 = newJObject()
  var body_598362 = newJObject()
  add(query_598361, "upload_protocol", newJString(uploadProtocol))
  add(query_598361, "fields", newJString(fields))
  add(query_598361, "quotaUser", newJString(quotaUser))
  add(query_598361, "alt", newJString(alt))
  add(query_598361, "oauth_token", newJString(oauthToken))
  add(query_598361, "callback", newJString(callback))
  add(query_598361, "access_token", newJString(accessToken))
  add(query_598361, "uploadType", newJString(uploadType))
  add(query_598361, "key", newJString(key))
  add(query_598361, "$.xgafv", newJString(Xgafv))
  add(path_598360, "resource", newJString(resource))
  if body != nil:
    body_598362 = body
  add(query_598361, "prettyPrint", newJBool(prettyPrint))
  result = call_598359.call(path_598360, query_598361, nil, nil, body_598362)

var cloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints* = Call_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_598342(
    name: "cloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:listAvailableOrgPolicyConstraints", validator: validate_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_598343,
    base: "/", url: url_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_598344,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsListOrgPolicies_598363 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerOrganizationsListOrgPolicies_598365(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":listOrgPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsListOrgPolicies_598364(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the `Policies` set for a particular resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name of the resource to list Policies for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598366 = path.getOrDefault("resource")
  valid_598366 = validateParameter(valid_598366, JString, required = true,
                                 default = nil)
  if valid_598366 != nil:
    section.add "resource", valid_598366
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
  var valid_598367 = query.getOrDefault("upload_protocol")
  valid_598367 = validateParameter(valid_598367, JString, required = false,
                                 default = nil)
  if valid_598367 != nil:
    section.add "upload_protocol", valid_598367
  var valid_598368 = query.getOrDefault("fields")
  valid_598368 = validateParameter(valid_598368, JString, required = false,
                                 default = nil)
  if valid_598368 != nil:
    section.add "fields", valid_598368
  var valid_598369 = query.getOrDefault("quotaUser")
  valid_598369 = validateParameter(valid_598369, JString, required = false,
                                 default = nil)
  if valid_598369 != nil:
    section.add "quotaUser", valid_598369
  var valid_598370 = query.getOrDefault("alt")
  valid_598370 = validateParameter(valid_598370, JString, required = false,
                                 default = newJString("json"))
  if valid_598370 != nil:
    section.add "alt", valid_598370
  var valid_598371 = query.getOrDefault("oauth_token")
  valid_598371 = validateParameter(valid_598371, JString, required = false,
                                 default = nil)
  if valid_598371 != nil:
    section.add "oauth_token", valid_598371
  var valid_598372 = query.getOrDefault("callback")
  valid_598372 = validateParameter(valid_598372, JString, required = false,
                                 default = nil)
  if valid_598372 != nil:
    section.add "callback", valid_598372
  var valid_598373 = query.getOrDefault("access_token")
  valid_598373 = validateParameter(valid_598373, JString, required = false,
                                 default = nil)
  if valid_598373 != nil:
    section.add "access_token", valid_598373
  var valid_598374 = query.getOrDefault("uploadType")
  valid_598374 = validateParameter(valid_598374, JString, required = false,
                                 default = nil)
  if valid_598374 != nil:
    section.add "uploadType", valid_598374
  var valid_598375 = query.getOrDefault("key")
  valid_598375 = validateParameter(valid_598375, JString, required = false,
                                 default = nil)
  if valid_598375 != nil:
    section.add "key", valid_598375
  var valid_598376 = query.getOrDefault("$.xgafv")
  valid_598376 = validateParameter(valid_598376, JString, required = false,
                                 default = newJString("1"))
  if valid_598376 != nil:
    section.add "$.xgafv", valid_598376
  var valid_598377 = query.getOrDefault("prettyPrint")
  valid_598377 = validateParameter(valid_598377, JBool, required = false,
                                 default = newJBool(true))
  if valid_598377 != nil:
    section.add "prettyPrint", valid_598377
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

proc call*(call_598379: Call_CloudresourcemanagerOrganizationsListOrgPolicies_598363;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the `Policies` set for a particular resource.
  ## 
  let valid = call_598379.validator(path, query, header, formData, body)
  let scheme = call_598379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598379.url(scheme.get, call_598379.host, call_598379.base,
                         call_598379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598379, url, valid)

proc call*(call_598380: Call_CloudresourcemanagerOrganizationsListOrgPolicies_598363;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsListOrgPolicies
  ## Lists all the `Policies` set for a particular resource.
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
  ##   resource: string (required)
  ##           : Name of the resource to list Policies for.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598381 = newJObject()
  var query_598382 = newJObject()
  var body_598383 = newJObject()
  add(query_598382, "upload_protocol", newJString(uploadProtocol))
  add(query_598382, "fields", newJString(fields))
  add(query_598382, "quotaUser", newJString(quotaUser))
  add(query_598382, "alt", newJString(alt))
  add(query_598382, "oauth_token", newJString(oauthToken))
  add(query_598382, "callback", newJString(callback))
  add(query_598382, "access_token", newJString(accessToken))
  add(query_598382, "uploadType", newJString(uploadType))
  add(query_598382, "key", newJString(key))
  add(query_598382, "$.xgafv", newJString(Xgafv))
  add(path_598381, "resource", newJString(resource))
  if body != nil:
    body_598383 = body
  add(query_598382, "prettyPrint", newJBool(prettyPrint))
  result = call_598380.call(path_598381, query_598382, nil, nil, body_598383)

var cloudresourcemanagerOrganizationsListOrgPolicies* = Call_CloudresourcemanagerOrganizationsListOrgPolicies_598363(
    name: "cloudresourcemanagerOrganizationsListOrgPolicies",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:listOrgPolicies",
    validator: validate_CloudresourcemanagerOrganizationsListOrgPolicies_598364,
    base: "/", url: url_CloudresourcemanagerOrganizationsListOrgPolicies_598365,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsSetIamPolicy_598384 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerOrganizationsSetIamPolicy_598386(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsSetIamPolicy_598385(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the access control policy on an Organization resource. Replaces any
  ## existing policy. The `resource` field should be the organization's resource
  ## name, e.g. "organizations/123".
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.organizations.setIamPolicy` on the specified organization
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598387 = path.getOrDefault("resource")
  valid_598387 = validateParameter(valid_598387, JString, required = true,
                                 default = nil)
  if valid_598387 != nil:
    section.add "resource", valid_598387
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
  var valid_598388 = query.getOrDefault("upload_protocol")
  valid_598388 = validateParameter(valid_598388, JString, required = false,
                                 default = nil)
  if valid_598388 != nil:
    section.add "upload_protocol", valid_598388
  var valid_598389 = query.getOrDefault("fields")
  valid_598389 = validateParameter(valid_598389, JString, required = false,
                                 default = nil)
  if valid_598389 != nil:
    section.add "fields", valid_598389
  var valid_598390 = query.getOrDefault("quotaUser")
  valid_598390 = validateParameter(valid_598390, JString, required = false,
                                 default = nil)
  if valid_598390 != nil:
    section.add "quotaUser", valid_598390
  var valid_598391 = query.getOrDefault("alt")
  valid_598391 = validateParameter(valid_598391, JString, required = false,
                                 default = newJString("json"))
  if valid_598391 != nil:
    section.add "alt", valid_598391
  var valid_598392 = query.getOrDefault("oauth_token")
  valid_598392 = validateParameter(valid_598392, JString, required = false,
                                 default = nil)
  if valid_598392 != nil:
    section.add "oauth_token", valid_598392
  var valid_598393 = query.getOrDefault("callback")
  valid_598393 = validateParameter(valid_598393, JString, required = false,
                                 default = nil)
  if valid_598393 != nil:
    section.add "callback", valid_598393
  var valid_598394 = query.getOrDefault("access_token")
  valid_598394 = validateParameter(valid_598394, JString, required = false,
                                 default = nil)
  if valid_598394 != nil:
    section.add "access_token", valid_598394
  var valid_598395 = query.getOrDefault("uploadType")
  valid_598395 = validateParameter(valid_598395, JString, required = false,
                                 default = nil)
  if valid_598395 != nil:
    section.add "uploadType", valid_598395
  var valid_598396 = query.getOrDefault("key")
  valid_598396 = validateParameter(valid_598396, JString, required = false,
                                 default = nil)
  if valid_598396 != nil:
    section.add "key", valid_598396
  var valid_598397 = query.getOrDefault("$.xgafv")
  valid_598397 = validateParameter(valid_598397, JString, required = false,
                                 default = newJString("1"))
  if valid_598397 != nil:
    section.add "$.xgafv", valid_598397
  var valid_598398 = query.getOrDefault("prettyPrint")
  valid_598398 = validateParameter(valid_598398, JBool, required = false,
                                 default = newJBool(true))
  if valid_598398 != nil:
    section.add "prettyPrint", valid_598398
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

proc call*(call_598400: Call_CloudresourcemanagerOrganizationsSetIamPolicy_598384;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on an Organization resource. Replaces any
  ## existing policy. The `resource` field should be the organization's resource
  ## name, e.g. "organizations/123".
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.organizations.setIamPolicy` on the specified organization
  ## 
  let valid = call_598400.validator(path, query, header, formData, body)
  let scheme = call_598400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598400.url(scheme.get, call_598400.host, call_598400.base,
                         call_598400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598400, url, valid)

proc call*(call_598401: Call_CloudresourcemanagerOrganizationsSetIamPolicy_598384;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsSetIamPolicy
  ## Sets the access control policy on an Organization resource. Replaces any
  ## existing policy. The `resource` field should be the organization's resource
  ## name, e.g. "organizations/123".
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.organizations.setIamPolicy` on the specified organization
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598402 = newJObject()
  var query_598403 = newJObject()
  var body_598404 = newJObject()
  add(query_598403, "upload_protocol", newJString(uploadProtocol))
  add(query_598403, "fields", newJString(fields))
  add(query_598403, "quotaUser", newJString(quotaUser))
  add(query_598403, "alt", newJString(alt))
  add(query_598403, "oauth_token", newJString(oauthToken))
  add(query_598403, "callback", newJString(callback))
  add(query_598403, "access_token", newJString(accessToken))
  add(query_598403, "uploadType", newJString(uploadType))
  add(query_598403, "key", newJString(key))
  add(query_598403, "$.xgafv", newJString(Xgafv))
  add(path_598402, "resource", newJString(resource))
  if body != nil:
    body_598404 = body
  add(query_598403, "prettyPrint", newJBool(prettyPrint))
  result = call_598401.call(path_598402, query_598403, nil, nil, body_598404)

var cloudresourcemanagerOrganizationsSetIamPolicy* = Call_CloudresourcemanagerOrganizationsSetIamPolicy_598384(
    name: "cloudresourcemanagerOrganizationsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_CloudresourcemanagerOrganizationsSetIamPolicy_598385,
    base: "/", url: url_CloudresourcemanagerOrganizationsSetIamPolicy_598386,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsSetOrgPolicy_598405 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerOrganizationsSetOrgPolicy_598407(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setOrgPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsSetOrgPolicy_598406(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the specified `Policy` on the resource. Creates a new `Policy` for
  ## that `Constraint` on the resource if one does not exist.
  ## 
  ## Not supplying an `etag` on the request `Policy` results in an unconditional
  ## write of the `Policy`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Resource name of the resource to attach the `Policy`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598408 = path.getOrDefault("resource")
  valid_598408 = validateParameter(valid_598408, JString, required = true,
                                 default = nil)
  if valid_598408 != nil:
    section.add "resource", valid_598408
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
  var valid_598409 = query.getOrDefault("upload_protocol")
  valid_598409 = validateParameter(valid_598409, JString, required = false,
                                 default = nil)
  if valid_598409 != nil:
    section.add "upload_protocol", valid_598409
  var valid_598410 = query.getOrDefault("fields")
  valid_598410 = validateParameter(valid_598410, JString, required = false,
                                 default = nil)
  if valid_598410 != nil:
    section.add "fields", valid_598410
  var valid_598411 = query.getOrDefault("quotaUser")
  valid_598411 = validateParameter(valid_598411, JString, required = false,
                                 default = nil)
  if valid_598411 != nil:
    section.add "quotaUser", valid_598411
  var valid_598412 = query.getOrDefault("alt")
  valid_598412 = validateParameter(valid_598412, JString, required = false,
                                 default = newJString("json"))
  if valid_598412 != nil:
    section.add "alt", valid_598412
  var valid_598413 = query.getOrDefault("oauth_token")
  valid_598413 = validateParameter(valid_598413, JString, required = false,
                                 default = nil)
  if valid_598413 != nil:
    section.add "oauth_token", valid_598413
  var valid_598414 = query.getOrDefault("callback")
  valid_598414 = validateParameter(valid_598414, JString, required = false,
                                 default = nil)
  if valid_598414 != nil:
    section.add "callback", valid_598414
  var valid_598415 = query.getOrDefault("access_token")
  valid_598415 = validateParameter(valid_598415, JString, required = false,
                                 default = nil)
  if valid_598415 != nil:
    section.add "access_token", valid_598415
  var valid_598416 = query.getOrDefault("uploadType")
  valid_598416 = validateParameter(valid_598416, JString, required = false,
                                 default = nil)
  if valid_598416 != nil:
    section.add "uploadType", valid_598416
  var valid_598417 = query.getOrDefault("key")
  valid_598417 = validateParameter(valid_598417, JString, required = false,
                                 default = nil)
  if valid_598417 != nil:
    section.add "key", valid_598417
  var valid_598418 = query.getOrDefault("$.xgafv")
  valid_598418 = validateParameter(valid_598418, JString, required = false,
                                 default = newJString("1"))
  if valid_598418 != nil:
    section.add "$.xgafv", valid_598418
  var valid_598419 = query.getOrDefault("prettyPrint")
  valid_598419 = validateParameter(valid_598419, JBool, required = false,
                                 default = newJBool(true))
  if valid_598419 != nil:
    section.add "prettyPrint", valid_598419
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

proc call*(call_598421: Call_CloudresourcemanagerOrganizationsSetOrgPolicy_598405;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified `Policy` on the resource. Creates a new `Policy` for
  ## that `Constraint` on the resource if one does not exist.
  ## 
  ## Not supplying an `etag` on the request `Policy` results in an unconditional
  ## write of the `Policy`.
  ## 
  let valid = call_598421.validator(path, query, header, formData, body)
  let scheme = call_598421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598421.url(scheme.get, call_598421.host, call_598421.base,
                         call_598421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598421, url, valid)

proc call*(call_598422: Call_CloudresourcemanagerOrganizationsSetOrgPolicy_598405;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsSetOrgPolicy
  ## Updates the specified `Policy` on the resource. Creates a new `Policy` for
  ## that `Constraint` on the resource if one does not exist.
  ## 
  ## Not supplying an `etag` on the request `Policy` results in an unconditional
  ## write of the `Policy`.
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
  ##   resource: string (required)
  ##           : Resource name of the resource to attach the `Policy`.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598423 = newJObject()
  var query_598424 = newJObject()
  var body_598425 = newJObject()
  add(query_598424, "upload_protocol", newJString(uploadProtocol))
  add(query_598424, "fields", newJString(fields))
  add(query_598424, "quotaUser", newJString(quotaUser))
  add(query_598424, "alt", newJString(alt))
  add(query_598424, "oauth_token", newJString(oauthToken))
  add(query_598424, "callback", newJString(callback))
  add(query_598424, "access_token", newJString(accessToken))
  add(query_598424, "uploadType", newJString(uploadType))
  add(query_598424, "key", newJString(key))
  add(query_598424, "$.xgafv", newJString(Xgafv))
  add(path_598423, "resource", newJString(resource))
  if body != nil:
    body_598425 = body
  add(query_598424, "prettyPrint", newJBool(prettyPrint))
  result = call_598422.call(path_598423, query_598424, nil, nil, body_598425)

var cloudresourcemanagerOrganizationsSetOrgPolicy* = Call_CloudresourcemanagerOrganizationsSetOrgPolicy_598405(
    name: "cloudresourcemanagerOrganizationsSetOrgPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:setOrgPolicy",
    validator: validate_CloudresourcemanagerOrganizationsSetOrgPolicy_598406,
    base: "/", url: url_CloudresourcemanagerOrganizationsSetOrgPolicy_598407,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsTestIamPermissions_598426 = ref object of OpenApiRestCall_597421
proc url_CloudresourcemanagerOrganizationsTestIamPermissions_598428(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerOrganizationsTestIamPermissions_598427(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified Organization.
  ## The `resource` field should be the organization's resource name,
  ## e.g. "organizations/123".
  ## 
  ## There are no permissions required for making this API call.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598429 = path.getOrDefault("resource")
  valid_598429 = validateParameter(valid_598429, JString, required = true,
                                 default = nil)
  if valid_598429 != nil:
    section.add "resource", valid_598429
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
  var valid_598430 = query.getOrDefault("upload_protocol")
  valid_598430 = validateParameter(valid_598430, JString, required = false,
                                 default = nil)
  if valid_598430 != nil:
    section.add "upload_protocol", valid_598430
  var valid_598431 = query.getOrDefault("fields")
  valid_598431 = validateParameter(valid_598431, JString, required = false,
                                 default = nil)
  if valid_598431 != nil:
    section.add "fields", valid_598431
  var valid_598432 = query.getOrDefault("quotaUser")
  valid_598432 = validateParameter(valid_598432, JString, required = false,
                                 default = nil)
  if valid_598432 != nil:
    section.add "quotaUser", valid_598432
  var valid_598433 = query.getOrDefault("alt")
  valid_598433 = validateParameter(valid_598433, JString, required = false,
                                 default = newJString("json"))
  if valid_598433 != nil:
    section.add "alt", valid_598433
  var valid_598434 = query.getOrDefault("oauth_token")
  valid_598434 = validateParameter(valid_598434, JString, required = false,
                                 default = nil)
  if valid_598434 != nil:
    section.add "oauth_token", valid_598434
  var valid_598435 = query.getOrDefault("callback")
  valid_598435 = validateParameter(valid_598435, JString, required = false,
                                 default = nil)
  if valid_598435 != nil:
    section.add "callback", valid_598435
  var valid_598436 = query.getOrDefault("access_token")
  valid_598436 = validateParameter(valid_598436, JString, required = false,
                                 default = nil)
  if valid_598436 != nil:
    section.add "access_token", valid_598436
  var valid_598437 = query.getOrDefault("uploadType")
  valid_598437 = validateParameter(valid_598437, JString, required = false,
                                 default = nil)
  if valid_598437 != nil:
    section.add "uploadType", valid_598437
  var valid_598438 = query.getOrDefault("key")
  valid_598438 = validateParameter(valid_598438, JString, required = false,
                                 default = nil)
  if valid_598438 != nil:
    section.add "key", valid_598438
  var valid_598439 = query.getOrDefault("$.xgafv")
  valid_598439 = validateParameter(valid_598439, JString, required = false,
                                 default = newJString("1"))
  if valid_598439 != nil:
    section.add "$.xgafv", valid_598439
  var valid_598440 = query.getOrDefault("prettyPrint")
  valid_598440 = validateParameter(valid_598440, JBool, required = false,
                                 default = newJBool(true))
  if valid_598440 != nil:
    section.add "prettyPrint", valid_598440
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

proc call*(call_598442: Call_CloudresourcemanagerOrganizationsTestIamPermissions_598426;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Organization.
  ## The `resource` field should be the organization's resource name,
  ## e.g. "organizations/123".
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_598442.validator(path, query, header, formData, body)
  let scheme = call_598442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598442.url(scheme.get, call_598442.host, call_598442.base,
                         call_598442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598442, url, valid)

proc call*(call_598443: Call_CloudresourcemanagerOrganizationsTestIamPermissions_598426;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudresourcemanagerOrganizationsTestIamPermissions
  ## Returns permissions that a caller has on the specified Organization.
  ## The `resource` field should be the organization's resource name,
  ## e.g. "organizations/123".
  ## 
  ## There are no permissions required for making this API call.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598444 = newJObject()
  var query_598445 = newJObject()
  var body_598446 = newJObject()
  add(query_598445, "upload_protocol", newJString(uploadProtocol))
  add(query_598445, "fields", newJString(fields))
  add(query_598445, "quotaUser", newJString(quotaUser))
  add(query_598445, "alt", newJString(alt))
  add(query_598445, "oauth_token", newJString(oauthToken))
  add(query_598445, "callback", newJString(callback))
  add(query_598445, "access_token", newJString(accessToken))
  add(query_598445, "uploadType", newJString(uploadType))
  add(query_598445, "key", newJString(key))
  add(query_598445, "$.xgafv", newJString(Xgafv))
  add(path_598444, "resource", newJString(resource))
  if body != nil:
    body_598446 = body
  add(query_598445, "prettyPrint", newJBool(prettyPrint))
  result = call_598443.call(path_598444, query_598445, nil, nil, body_598446)

var cloudresourcemanagerOrganizationsTestIamPermissions* = Call_CloudresourcemanagerOrganizationsTestIamPermissions_598426(
    name: "cloudresourcemanagerOrganizationsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_CloudresourcemanagerOrganizationsTestIamPermissions_598427,
    base: "/", url: url_CloudresourcemanagerOrganizationsTestIamPermissions_598428,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
