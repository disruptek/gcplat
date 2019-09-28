
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudresourcemanagerLiensCreate_579965 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerLiensCreate_579967(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerLiensCreate_579966(path: JsonNode;
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
  var valid_579968 = query.getOrDefault("upload_protocol")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "upload_protocol", valid_579968
  var valid_579969 = query.getOrDefault("fields")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "fields", valid_579969
  var valid_579970 = query.getOrDefault("quotaUser")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "quotaUser", valid_579970
  var valid_579971 = query.getOrDefault("alt")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = newJString("json"))
  if valid_579971 != nil:
    section.add "alt", valid_579971
  var valid_579972 = query.getOrDefault("oauth_token")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "oauth_token", valid_579972
  var valid_579973 = query.getOrDefault("callback")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "callback", valid_579973
  var valid_579974 = query.getOrDefault("access_token")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "access_token", valid_579974
  var valid_579975 = query.getOrDefault("uploadType")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "uploadType", valid_579975
  var valid_579976 = query.getOrDefault("key")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "key", valid_579976
  var valid_579977 = query.getOrDefault("$.xgafv")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = newJString("1"))
  if valid_579977 != nil:
    section.add "$.xgafv", valid_579977
  var valid_579978 = query.getOrDefault("prettyPrint")
  valid_579978 = validateParameter(valid_579978, JBool, required = false,
                                 default = newJBool(true))
  if valid_579978 != nil:
    section.add "prettyPrint", valid_579978
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

proc call*(call_579980: Call_CloudresourcemanagerLiensCreate_579965;
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
  let valid = call_579980.validator(path, query, header, formData, body)
  let scheme = call_579980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579980.url(scheme.get, call_579980.host, call_579980.base,
                         call_579980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579980, url, valid)

proc call*(call_579981: Call_CloudresourcemanagerLiensCreate_579965;
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
  var query_579982 = newJObject()
  var body_579983 = newJObject()
  add(query_579982, "upload_protocol", newJString(uploadProtocol))
  add(query_579982, "fields", newJString(fields))
  add(query_579982, "quotaUser", newJString(quotaUser))
  add(query_579982, "alt", newJString(alt))
  add(query_579982, "oauth_token", newJString(oauthToken))
  add(query_579982, "callback", newJString(callback))
  add(query_579982, "access_token", newJString(accessToken))
  add(query_579982, "uploadType", newJString(uploadType))
  add(query_579982, "key", newJString(key))
  add(query_579982, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579983 = body
  add(query_579982, "prettyPrint", newJBool(prettyPrint))
  result = call_579981.call(nil, query_579982, nil, nil, body_579983)

var cloudresourcemanagerLiensCreate* = Call_CloudresourcemanagerLiensCreate_579965(
    name: "cloudresourcemanagerLiensCreate", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/liens",
    validator: validate_CloudresourcemanagerLiensCreate_579966, base: "/",
    url: url_CloudresourcemanagerLiensCreate_579967, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerLiensList_579690 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerLiensList_579692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerLiensList_579691(path: JsonNode; query: JsonNode;
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
  var valid_579804 = query.getOrDefault("upload_protocol")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "upload_protocol", valid_579804
  var valid_579805 = query.getOrDefault("fields")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "fields", valid_579805
  var valid_579806 = query.getOrDefault("pageToken")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "pageToken", valid_579806
  var valid_579807 = query.getOrDefault("quotaUser")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "quotaUser", valid_579807
  var valid_579821 = query.getOrDefault("alt")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = newJString("json"))
  if valid_579821 != nil:
    section.add "alt", valid_579821
  var valid_579822 = query.getOrDefault("oauth_token")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "oauth_token", valid_579822
  var valid_579823 = query.getOrDefault("callback")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "callback", valid_579823
  var valid_579824 = query.getOrDefault("access_token")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "access_token", valid_579824
  var valid_579825 = query.getOrDefault("uploadType")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "uploadType", valid_579825
  var valid_579826 = query.getOrDefault("parent")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "parent", valid_579826
  var valid_579827 = query.getOrDefault("key")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "key", valid_579827
  var valid_579828 = query.getOrDefault("$.xgafv")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = newJString("1"))
  if valid_579828 != nil:
    section.add "$.xgafv", valid_579828
  var valid_579829 = query.getOrDefault("pageSize")
  valid_579829 = validateParameter(valid_579829, JInt, required = false, default = nil)
  if valid_579829 != nil:
    section.add "pageSize", valid_579829
  var valid_579830 = query.getOrDefault("prettyPrint")
  valid_579830 = validateParameter(valid_579830, JBool, required = false,
                                 default = newJBool(true))
  if valid_579830 != nil:
    section.add "prettyPrint", valid_579830
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579853: Call_CloudresourcemanagerLiensList_579690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all Liens applied to the `parent` resource.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, a Lien with a `parent` of `projects/1234` requires permission
  ## `resourcemanager.projects.get`.
  ## 
  let valid = call_579853.validator(path, query, header, formData, body)
  let scheme = call_579853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579853.url(scheme.get, call_579853.host, call_579853.base,
                         call_579853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579853, url, valid)

proc call*(call_579924: Call_CloudresourcemanagerLiensList_579690;
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
  var query_579925 = newJObject()
  add(query_579925, "upload_protocol", newJString(uploadProtocol))
  add(query_579925, "fields", newJString(fields))
  add(query_579925, "pageToken", newJString(pageToken))
  add(query_579925, "quotaUser", newJString(quotaUser))
  add(query_579925, "alt", newJString(alt))
  add(query_579925, "oauth_token", newJString(oauthToken))
  add(query_579925, "callback", newJString(callback))
  add(query_579925, "access_token", newJString(accessToken))
  add(query_579925, "uploadType", newJString(uploadType))
  add(query_579925, "parent", newJString(parent))
  add(query_579925, "key", newJString(key))
  add(query_579925, "$.xgafv", newJString(Xgafv))
  add(query_579925, "pageSize", newJInt(pageSize))
  add(query_579925, "prettyPrint", newJBool(prettyPrint))
  result = call_579924.call(nil, query_579925, nil, nil, nil)

var cloudresourcemanagerLiensList* = Call_CloudresourcemanagerLiensList_579690(
    name: "cloudresourcemanagerLiensList", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/liens",
    validator: validate_CloudresourcemanagerLiensList_579691, base: "/",
    url: url_CloudresourcemanagerLiensList_579692, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsSearch_579984 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerOrganizationsSearch_579986(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerOrganizationsSearch_579985(path: JsonNode;
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
  var valid_579987 = query.getOrDefault("upload_protocol")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "upload_protocol", valid_579987
  var valid_579988 = query.getOrDefault("fields")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "fields", valid_579988
  var valid_579989 = query.getOrDefault("quotaUser")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "quotaUser", valid_579989
  var valid_579990 = query.getOrDefault("alt")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = newJString("json"))
  if valid_579990 != nil:
    section.add "alt", valid_579990
  var valid_579991 = query.getOrDefault("oauth_token")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "oauth_token", valid_579991
  var valid_579992 = query.getOrDefault("callback")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "callback", valid_579992
  var valid_579993 = query.getOrDefault("access_token")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "access_token", valid_579993
  var valid_579994 = query.getOrDefault("uploadType")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "uploadType", valid_579994
  var valid_579995 = query.getOrDefault("key")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "key", valid_579995
  var valid_579996 = query.getOrDefault("$.xgafv")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = newJString("1"))
  if valid_579996 != nil:
    section.add "$.xgafv", valid_579996
  var valid_579997 = query.getOrDefault("prettyPrint")
  valid_579997 = validateParameter(valid_579997, JBool, required = false,
                                 default = newJBool(true))
  if valid_579997 != nil:
    section.add "prettyPrint", valid_579997
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

proc call*(call_579999: Call_CloudresourcemanagerOrganizationsSearch_579984;
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
  let valid = call_579999.validator(path, query, header, formData, body)
  let scheme = call_579999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579999.url(scheme.get, call_579999.host, call_579999.base,
                         call_579999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579999, url, valid)

proc call*(call_580000: Call_CloudresourcemanagerOrganizationsSearch_579984;
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
  var query_580001 = newJObject()
  var body_580002 = newJObject()
  add(query_580001, "upload_protocol", newJString(uploadProtocol))
  add(query_580001, "fields", newJString(fields))
  add(query_580001, "quotaUser", newJString(quotaUser))
  add(query_580001, "alt", newJString(alt))
  add(query_580001, "oauth_token", newJString(oauthToken))
  add(query_580001, "callback", newJString(callback))
  add(query_580001, "access_token", newJString(accessToken))
  add(query_580001, "uploadType", newJString(uploadType))
  add(query_580001, "key", newJString(key))
  add(query_580001, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580002 = body
  add(query_580001, "prettyPrint", newJBool(prettyPrint))
  result = call_580000.call(nil, query_580001, nil, nil, body_580002)

var cloudresourcemanagerOrganizationsSearch* = Call_CloudresourcemanagerOrganizationsSearch_579984(
    name: "cloudresourcemanagerOrganizationsSearch", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/organizations:search",
    validator: validate_CloudresourcemanagerOrganizationsSearch_579985, base: "/",
    url: url_CloudresourcemanagerOrganizationsSearch_579986,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsCreate_580023 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerProjectsCreate_580025(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerProjectsCreate_580024(path: JsonNode;
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
  var valid_580026 = query.getOrDefault("upload_protocol")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "upload_protocol", valid_580026
  var valid_580027 = query.getOrDefault("fields")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "fields", valid_580027
  var valid_580028 = query.getOrDefault("quotaUser")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "quotaUser", valid_580028
  var valid_580029 = query.getOrDefault("alt")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = newJString("json"))
  if valid_580029 != nil:
    section.add "alt", valid_580029
  var valid_580030 = query.getOrDefault("oauth_token")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "oauth_token", valid_580030
  var valid_580031 = query.getOrDefault("callback")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "callback", valid_580031
  var valid_580032 = query.getOrDefault("access_token")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "access_token", valid_580032
  var valid_580033 = query.getOrDefault("uploadType")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "uploadType", valid_580033
  var valid_580034 = query.getOrDefault("key")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "key", valid_580034
  var valid_580035 = query.getOrDefault("$.xgafv")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("1"))
  if valid_580035 != nil:
    section.add "$.xgafv", valid_580035
  var valid_580036 = query.getOrDefault("prettyPrint")
  valid_580036 = validateParameter(valid_580036, JBool, required = false,
                                 default = newJBool(true))
  if valid_580036 != nil:
    section.add "prettyPrint", valid_580036
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

proc call*(call_580038: Call_CloudresourcemanagerProjectsCreate_580023;
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
  let valid = call_580038.validator(path, query, header, formData, body)
  let scheme = call_580038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580038.url(scheme.get, call_580038.host, call_580038.base,
                         call_580038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580038, url, valid)

proc call*(call_580039: Call_CloudresourcemanagerProjectsCreate_580023;
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
  var query_580040 = newJObject()
  var body_580041 = newJObject()
  add(query_580040, "upload_protocol", newJString(uploadProtocol))
  add(query_580040, "fields", newJString(fields))
  add(query_580040, "quotaUser", newJString(quotaUser))
  add(query_580040, "alt", newJString(alt))
  add(query_580040, "oauth_token", newJString(oauthToken))
  add(query_580040, "callback", newJString(callback))
  add(query_580040, "access_token", newJString(accessToken))
  add(query_580040, "uploadType", newJString(uploadType))
  add(query_580040, "key", newJString(key))
  add(query_580040, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580041 = body
  add(query_580040, "prettyPrint", newJBool(prettyPrint))
  result = call_580039.call(nil, query_580040, nil, nil, body_580041)

var cloudresourcemanagerProjectsCreate* = Call_CloudresourcemanagerProjectsCreate_580023(
    name: "cloudresourcemanagerProjectsCreate", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/projects",
    validator: validate_CloudresourcemanagerProjectsCreate_580024, base: "/",
    url: url_CloudresourcemanagerProjectsCreate_580025, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsList_580003 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerProjectsList_580005(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudresourcemanagerProjectsList_580004(path: JsonNode;
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
  var valid_580006 = query.getOrDefault("upload_protocol")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "upload_protocol", valid_580006
  var valid_580007 = query.getOrDefault("fields")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "fields", valid_580007
  var valid_580008 = query.getOrDefault("pageToken")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "pageToken", valid_580008
  var valid_580009 = query.getOrDefault("quotaUser")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "quotaUser", valid_580009
  var valid_580010 = query.getOrDefault("alt")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = newJString("json"))
  if valid_580010 != nil:
    section.add "alt", valid_580010
  var valid_580011 = query.getOrDefault("oauth_token")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "oauth_token", valid_580011
  var valid_580012 = query.getOrDefault("callback")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "callback", valid_580012
  var valid_580013 = query.getOrDefault("access_token")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "access_token", valid_580013
  var valid_580014 = query.getOrDefault("uploadType")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "uploadType", valid_580014
  var valid_580015 = query.getOrDefault("key")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "key", valid_580015
  var valid_580016 = query.getOrDefault("$.xgafv")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = newJString("1"))
  if valid_580016 != nil:
    section.add "$.xgafv", valid_580016
  var valid_580017 = query.getOrDefault("pageSize")
  valid_580017 = validateParameter(valid_580017, JInt, required = false, default = nil)
  if valid_580017 != nil:
    section.add "pageSize", valid_580017
  var valid_580018 = query.getOrDefault("prettyPrint")
  valid_580018 = validateParameter(valid_580018, JBool, required = false,
                                 default = newJBool(true))
  if valid_580018 != nil:
    section.add "prettyPrint", valid_580018
  var valid_580019 = query.getOrDefault("filter")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "filter", valid_580019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580020: Call_CloudresourcemanagerProjectsList_580003;
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
  let valid = call_580020.validator(path, query, header, formData, body)
  let scheme = call_580020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580020.url(scheme.get, call_580020.host, call_580020.base,
                         call_580020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580020, url, valid)

proc call*(call_580021: Call_CloudresourcemanagerProjectsList_580003;
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
  var query_580022 = newJObject()
  add(query_580022, "upload_protocol", newJString(uploadProtocol))
  add(query_580022, "fields", newJString(fields))
  add(query_580022, "pageToken", newJString(pageToken))
  add(query_580022, "quotaUser", newJString(quotaUser))
  add(query_580022, "alt", newJString(alt))
  add(query_580022, "oauth_token", newJString(oauthToken))
  add(query_580022, "callback", newJString(callback))
  add(query_580022, "access_token", newJString(accessToken))
  add(query_580022, "uploadType", newJString(uploadType))
  add(query_580022, "key", newJString(key))
  add(query_580022, "$.xgafv", newJString(Xgafv))
  add(query_580022, "pageSize", newJInt(pageSize))
  add(query_580022, "prettyPrint", newJBool(prettyPrint))
  add(query_580022, "filter", newJString(filter))
  result = call_580021.call(nil, query_580022, nil, nil, nil)

var cloudresourcemanagerProjectsList* = Call_CloudresourcemanagerProjectsList_580003(
    name: "cloudresourcemanagerProjectsList", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/projects",
    validator: validate_CloudresourcemanagerProjectsList_580004, base: "/",
    url: url_CloudresourcemanagerProjectsList_580005, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsUpdate_580075 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerProjectsUpdate_580077(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsUpdate_580076(path: JsonNode;
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
  var valid_580078 = path.getOrDefault("projectId")
  valid_580078 = validateParameter(valid_580078, JString, required = true,
                                 default = nil)
  if valid_580078 != nil:
    section.add "projectId", valid_580078
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
  var valid_580079 = query.getOrDefault("upload_protocol")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "upload_protocol", valid_580079
  var valid_580080 = query.getOrDefault("fields")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "fields", valid_580080
  var valid_580081 = query.getOrDefault("quotaUser")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "quotaUser", valid_580081
  var valid_580082 = query.getOrDefault("alt")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = newJString("json"))
  if valid_580082 != nil:
    section.add "alt", valid_580082
  var valid_580083 = query.getOrDefault("oauth_token")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "oauth_token", valid_580083
  var valid_580084 = query.getOrDefault("callback")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "callback", valid_580084
  var valid_580085 = query.getOrDefault("access_token")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "access_token", valid_580085
  var valid_580086 = query.getOrDefault("uploadType")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "uploadType", valid_580086
  var valid_580087 = query.getOrDefault("key")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "key", valid_580087
  var valid_580088 = query.getOrDefault("$.xgafv")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = newJString("1"))
  if valid_580088 != nil:
    section.add "$.xgafv", valid_580088
  var valid_580089 = query.getOrDefault("prettyPrint")
  valid_580089 = validateParameter(valid_580089, JBool, required = false,
                                 default = newJBool(true))
  if valid_580089 != nil:
    section.add "prettyPrint", valid_580089
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

proc call*(call_580091: Call_CloudresourcemanagerProjectsUpdate_580075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the attributes of the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have modify permissions for this Project.
  ## 
  let valid = call_580091.validator(path, query, header, formData, body)
  let scheme = call_580091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580091.url(scheme.get, call_580091.host, call_580091.base,
                         call_580091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580091, url, valid)

proc call*(call_580092: Call_CloudresourcemanagerProjectsUpdate_580075;
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
  var path_580093 = newJObject()
  var query_580094 = newJObject()
  var body_580095 = newJObject()
  add(query_580094, "upload_protocol", newJString(uploadProtocol))
  add(query_580094, "fields", newJString(fields))
  add(query_580094, "quotaUser", newJString(quotaUser))
  add(query_580094, "alt", newJString(alt))
  add(query_580094, "oauth_token", newJString(oauthToken))
  add(query_580094, "callback", newJString(callback))
  add(query_580094, "access_token", newJString(accessToken))
  add(query_580094, "uploadType", newJString(uploadType))
  add(query_580094, "key", newJString(key))
  add(path_580093, "projectId", newJString(projectId))
  add(query_580094, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580095 = body
  add(query_580094, "prettyPrint", newJBool(prettyPrint))
  result = call_580092.call(path_580093, query_580094, nil, nil, body_580095)

var cloudresourcemanagerProjectsUpdate* = Call_CloudresourcemanagerProjectsUpdate_580075(
    name: "cloudresourcemanagerProjectsUpdate", meth: HttpMethod.HttpPut,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{projectId}",
    validator: validate_CloudresourcemanagerProjectsUpdate_580076, base: "/",
    url: url_CloudresourcemanagerProjectsUpdate_580077, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsGet_580042 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerProjectsGet_580044(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsGet_580043(path: JsonNode;
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
  var valid_580059 = path.getOrDefault("projectId")
  valid_580059 = validateParameter(valid_580059, JString, required = true,
                                 default = nil)
  if valid_580059 != nil:
    section.add "projectId", valid_580059
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
  var valid_580060 = query.getOrDefault("upload_protocol")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "upload_protocol", valid_580060
  var valid_580061 = query.getOrDefault("fields")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "fields", valid_580061
  var valid_580062 = query.getOrDefault("quotaUser")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "quotaUser", valid_580062
  var valid_580063 = query.getOrDefault("alt")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = newJString("json"))
  if valid_580063 != nil:
    section.add "alt", valid_580063
  var valid_580064 = query.getOrDefault("oauth_token")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "oauth_token", valid_580064
  var valid_580065 = query.getOrDefault("callback")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "callback", valid_580065
  var valid_580066 = query.getOrDefault("access_token")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "access_token", valid_580066
  var valid_580067 = query.getOrDefault("uploadType")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "uploadType", valid_580067
  var valid_580068 = query.getOrDefault("key")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "key", valid_580068
  var valid_580069 = query.getOrDefault("$.xgafv")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = newJString("1"))
  if valid_580069 != nil:
    section.add "$.xgafv", valid_580069
  var valid_580070 = query.getOrDefault("prettyPrint")
  valid_580070 = validateParameter(valid_580070, JBool, required = false,
                                 default = newJBool(true))
  if valid_580070 != nil:
    section.add "prettyPrint", valid_580070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580071: Call_CloudresourcemanagerProjectsGet_580042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the Project identified by the specified
  ## `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
  ## 
  let valid = call_580071.validator(path, query, header, formData, body)
  let scheme = call_580071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580071.url(scheme.get, call_580071.host, call_580071.base,
                         call_580071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580071, url, valid)

proc call*(call_580072: Call_CloudresourcemanagerProjectsGet_580042;
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
  var path_580073 = newJObject()
  var query_580074 = newJObject()
  add(query_580074, "upload_protocol", newJString(uploadProtocol))
  add(query_580074, "fields", newJString(fields))
  add(query_580074, "quotaUser", newJString(quotaUser))
  add(query_580074, "alt", newJString(alt))
  add(query_580074, "oauth_token", newJString(oauthToken))
  add(query_580074, "callback", newJString(callback))
  add(query_580074, "access_token", newJString(accessToken))
  add(query_580074, "uploadType", newJString(uploadType))
  add(query_580074, "key", newJString(key))
  add(path_580073, "projectId", newJString(projectId))
  add(query_580074, "$.xgafv", newJString(Xgafv))
  add(query_580074, "prettyPrint", newJBool(prettyPrint))
  result = call_580072.call(path_580073, query_580074, nil, nil, nil)

var cloudresourcemanagerProjectsGet* = Call_CloudresourcemanagerProjectsGet_580042(
    name: "cloudresourcemanagerProjectsGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{projectId}",
    validator: validate_CloudresourcemanagerProjectsGet_580043, base: "/",
    url: url_CloudresourcemanagerProjectsGet_580044, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsDelete_580096 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerProjectsDelete_580098(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudresourcemanagerProjectsDelete_580097(path: JsonNode;
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
  var valid_580099 = path.getOrDefault("projectId")
  valid_580099 = validateParameter(valid_580099, JString, required = true,
                                 default = nil)
  if valid_580099 != nil:
    section.add "projectId", valid_580099
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
  var valid_580100 = query.getOrDefault("upload_protocol")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "upload_protocol", valid_580100
  var valid_580101 = query.getOrDefault("fields")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "fields", valid_580101
  var valid_580102 = query.getOrDefault("quotaUser")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "quotaUser", valid_580102
  var valid_580103 = query.getOrDefault("alt")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = newJString("json"))
  if valid_580103 != nil:
    section.add "alt", valid_580103
  var valid_580104 = query.getOrDefault("oauth_token")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "oauth_token", valid_580104
  var valid_580105 = query.getOrDefault("callback")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "callback", valid_580105
  var valid_580106 = query.getOrDefault("access_token")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "access_token", valid_580106
  var valid_580107 = query.getOrDefault("uploadType")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "uploadType", valid_580107
  var valid_580108 = query.getOrDefault("key")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "key", valid_580108
  var valid_580109 = query.getOrDefault("$.xgafv")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = newJString("1"))
  if valid_580109 != nil:
    section.add "$.xgafv", valid_580109
  var valid_580110 = query.getOrDefault("prettyPrint")
  valid_580110 = validateParameter(valid_580110, JBool, required = false,
                                 default = newJBool(true))
  if valid_580110 != nil:
    section.add "prettyPrint", valid_580110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580111: Call_CloudresourcemanagerProjectsDelete_580096;
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
  let valid = call_580111.validator(path, query, header, formData, body)
  let scheme = call_580111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580111.url(scheme.get, call_580111.host, call_580111.base,
                         call_580111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580111, url, valid)

proc call*(call_580112: Call_CloudresourcemanagerProjectsDelete_580096;
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
  var path_580113 = newJObject()
  var query_580114 = newJObject()
  add(query_580114, "upload_protocol", newJString(uploadProtocol))
  add(query_580114, "fields", newJString(fields))
  add(query_580114, "quotaUser", newJString(quotaUser))
  add(query_580114, "alt", newJString(alt))
  add(query_580114, "oauth_token", newJString(oauthToken))
  add(query_580114, "callback", newJString(callback))
  add(query_580114, "access_token", newJString(accessToken))
  add(query_580114, "uploadType", newJString(uploadType))
  add(query_580114, "key", newJString(key))
  add(path_580113, "projectId", newJString(projectId))
  add(query_580114, "$.xgafv", newJString(Xgafv))
  add(query_580114, "prettyPrint", newJBool(prettyPrint))
  result = call_580112.call(path_580113, query_580114, nil, nil, nil)

var cloudresourcemanagerProjectsDelete* = Call_CloudresourcemanagerProjectsDelete_580096(
    name: "cloudresourcemanagerProjectsDelete", meth: HttpMethod.HttpDelete,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{projectId}",
    validator: validate_CloudresourcemanagerProjectsDelete_580097, base: "/",
    url: url_CloudresourcemanagerProjectsDelete_580098, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsGetAncestry_580115 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerProjectsGetAncestry_580117(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerProjectsGetAncestry_580116(path: JsonNode;
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
  var valid_580118 = path.getOrDefault("projectId")
  valid_580118 = validateParameter(valid_580118, JString, required = true,
                                 default = nil)
  if valid_580118 != nil:
    section.add "projectId", valid_580118
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
  var valid_580119 = query.getOrDefault("upload_protocol")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "upload_protocol", valid_580119
  var valid_580120 = query.getOrDefault("fields")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "fields", valid_580120
  var valid_580121 = query.getOrDefault("quotaUser")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "quotaUser", valid_580121
  var valid_580122 = query.getOrDefault("alt")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = newJString("json"))
  if valid_580122 != nil:
    section.add "alt", valid_580122
  var valid_580123 = query.getOrDefault("oauth_token")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "oauth_token", valid_580123
  var valid_580124 = query.getOrDefault("callback")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "callback", valid_580124
  var valid_580125 = query.getOrDefault("access_token")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "access_token", valid_580125
  var valid_580126 = query.getOrDefault("uploadType")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "uploadType", valid_580126
  var valid_580127 = query.getOrDefault("key")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "key", valid_580127
  var valid_580128 = query.getOrDefault("$.xgafv")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = newJString("1"))
  if valid_580128 != nil:
    section.add "$.xgafv", valid_580128
  var valid_580129 = query.getOrDefault("prettyPrint")
  valid_580129 = validateParameter(valid_580129, JBool, required = false,
                                 default = newJBool(true))
  if valid_580129 != nil:
    section.add "prettyPrint", valid_580129
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

proc call*(call_580131: Call_CloudresourcemanagerProjectsGetAncestry_580115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of ancestors in the resource hierarchy for the Project
  ## identified by the specified `project_id` (for example, `my-project-123`).
  ## 
  ## The caller must have read permissions for this Project.
  ## 
  let valid = call_580131.validator(path, query, header, formData, body)
  let scheme = call_580131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580131.url(scheme.get, call_580131.host, call_580131.base,
                         call_580131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580131, url, valid)

proc call*(call_580132: Call_CloudresourcemanagerProjectsGetAncestry_580115;
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
  var path_580133 = newJObject()
  var query_580134 = newJObject()
  var body_580135 = newJObject()
  add(query_580134, "upload_protocol", newJString(uploadProtocol))
  add(query_580134, "fields", newJString(fields))
  add(query_580134, "quotaUser", newJString(quotaUser))
  add(query_580134, "alt", newJString(alt))
  add(query_580134, "oauth_token", newJString(oauthToken))
  add(query_580134, "callback", newJString(callback))
  add(query_580134, "access_token", newJString(accessToken))
  add(query_580134, "uploadType", newJString(uploadType))
  add(query_580134, "key", newJString(key))
  add(path_580133, "projectId", newJString(projectId))
  add(query_580134, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580135 = body
  add(query_580134, "prettyPrint", newJBool(prettyPrint))
  result = call_580132.call(path_580133, query_580134, nil, nil, body_580135)

var cloudresourcemanagerProjectsGetAncestry* = Call_CloudresourcemanagerProjectsGetAncestry_580115(
    name: "cloudresourcemanagerProjectsGetAncestry", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{projectId}:getAncestry",
    validator: validate_CloudresourcemanagerProjectsGetAncestry_580116, base: "/",
    url: url_CloudresourcemanagerProjectsGetAncestry_580117,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsUndelete_580136 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerProjectsUndelete_580138(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerProjectsUndelete_580137(path: JsonNode;
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
  var valid_580139 = path.getOrDefault("projectId")
  valid_580139 = validateParameter(valid_580139, JString, required = true,
                                 default = nil)
  if valid_580139 != nil:
    section.add "projectId", valid_580139
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
  var valid_580140 = query.getOrDefault("upload_protocol")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "upload_protocol", valid_580140
  var valid_580141 = query.getOrDefault("fields")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "fields", valid_580141
  var valid_580142 = query.getOrDefault("quotaUser")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "quotaUser", valid_580142
  var valid_580143 = query.getOrDefault("alt")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = newJString("json"))
  if valid_580143 != nil:
    section.add "alt", valid_580143
  var valid_580144 = query.getOrDefault("oauth_token")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "oauth_token", valid_580144
  var valid_580145 = query.getOrDefault("callback")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "callback", valid_580145
  var valid_580146 = query.getOrDefault("access_token")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "access_token", valid_580146
  var valid_580147 = query.getOrDefault("uploadType")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "uploadType", valid_580147
  var valid_580148 = query.getOrDefault("key")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "key", valid_580148
  var valid_580149 = query.getOrDefault("$.xgafv")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = newJString("1"))
  if valid_580149 != nil:
    section.add "$.xgafv", valid_580149
  var valid_580150 = query.getOrDefault("prettyPrint")
  valid_580150 = validateParameter(valid_580150, JBool, required = false,
                                 default = newJBool(true))
  if valid_580150 != nil:
    section.add "prettyPrint", valid_580150
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

proc call*(call_580152: Call_CloudresourcemanagerProjectsUndelete_580136;
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
  let valid = call_580152.validator(path, query, header, formData, body)
  let scheme = call_580152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580152.url(scheme.get, call_580152.host, call_580152.base,
                         call_580152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580152, url, valid)

proc call*(call_580153: Call_CloudresourcemanagerProjectsUndelete_580136;
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
  var path_580154 = newJObject()
  var query_580155 = newJObject()
  var body_580156 = newJObject()
  add(query_580155, "upload_protocol", newJString(uploadProtocol))
  add(query_580155, "fields", newJString(fields))
  add(query_580155, "quotaUser", newJString(quotaUser))
  add(query_580155, "alt", newJString(alt))
  add(query_580155, "oauth_token", newJString(oauthToken))
  add(query_580155, "callback", newJString(callback))
  add(query_580155, "access_token", newJString(accessToken))
  add(query_580155, "uploadType", newJString(uploadType))
  add(query_580155, "key", newJString(key))
  add(path_580154, "projectId", newJString(projectId))
  add(query_580155, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580156 = body
  add(query_580155, "prettyPrint", newJBool(prettyPrint))
  result = call_580153.call(path_580154, query_580155, nil, nil, body_580156)

var cloudresourcemanagerProjectsUndelete* = Call_CloudresourcemanagerProjectsUndelete_580136(
    name: "cloudresourcemanagerProjectsUndelete", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{projectId}:undelete",
    validator: validate_CloudresourcemanagerProjectsUndelete_580137, base: "/",
    url: url_CloudresourcemanagerProjectsUndelete_580138, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsGetIamPolicy_580157 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerProjectsGetIamPolicy_580159(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerProjectsGetIamPolicy_580158(path: JsonNode;
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
  var valid_580160 = path.getOrDefault("resource")
  valid_580160 = validateParameter(valid_580160, JString, required = true,
                                 default = nil)
  if valid_580160 != nil:
    section.add "resource", valid_580160
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
  var valid_580161 = query.getOrDefault("upload_protocol")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "upload_protocol", valid_580161
  var valid_580162 = query.getOrDefault("fields")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "fields", valid_580162
  var valid_580163 = query.getOrDefault("quotaUser")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "quotaUser", valid_580163
  var valid_580164 = query.getOrDefault("alt")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = newJString("json"))
  if valid_580164 != nil:
    section.add "alt", valid_580164
  var valid_580165 = query.getOrDefault("oauth_token")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "oauth_token", valid_580165
  var valid_580166 = query.getOrDefault("callback")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "callback", valid_580166
  var valid_580167 = query.getOrDefault("access_token")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "access_token", valid_580167
  var valid_580168 = query.getOrDefault("uploadType")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "uploadType", valid_580168
  var valid_580169 = query.getOrDefault("key")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "key", valid_580169
  var valid_580170 = query.getOrDefault("$.xgafv")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = newJString("1"))
  if valid_580170 != nil:
    section.add "$.xgafv", valid_580170
  var valid_580171 = query.getOrDefault("prettyPrint")
  valid_580171 = validateParameter(valid_580171, JBool, required = false,
                                 default = newJBool(true))
  if valid_580171 != nil:
    section.add "prettyPrint", valid_580171
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

proc call*(call_580173: Call_CloudresourcemanagerProjectsGetIamPolicy_580157;
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
  let valid = call_580173.validator(path, query, header, formData, body)
  let scheme = call_580173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580173.url(scheme.get, call_580173.host, call_580173.base,
                         call_580173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580173, url, valid)

proc call*(call_580174: Call_CloudresourcemanagerProjectsGetIamPolicy_580157;
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
  var path_580175 = newJObject()
  var query_580176 = newJObject()
  var body_580177 = newJObject()
  add(query_580176, "upload_protocol", newJString(uploadProtocol))
  add(query_580176, "fields", newJString(fields))
  add(query_580176, "quotaUser", newJString(quotaUser))
  add(query_580176, "alt", newJString(alt))
  add(query_580176, "oauth_token", newJString(oauthToken))
  add(query_580176, "callback", newJString(callback))
  add(query_580176, "access_token", newJString(accessToken))
  add(query_580176, "uploadType", newJString(uploadType))
  add(query_580176, "key", newJString(key))
  add(query_580176, "$.xgafv", newJString(Xgafv))
  add(path_580175, "resource", newJString(resource))
  if body != nil:
    body_580177 = body
  add(query_580176, "prettyPrint", newJBool(prettyPrint))
  result = call_580174.call(path_580175, query_580176, nil, nil, body_580177)

var cloudresourcemanagerProjectsGetIamPolicy* = Call_CloudresourcemanagerProjectsGetIamPolicy_580157(
    name: "cloudresourcemanagerProjectsGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{resource}:getIamPolicy",
    validator: validate_CloudresourcemanagerProjectsGetIamPolicy_580158,
    base: "/", url: url_CloudresourcemanagerProjectsGetIamPolicy_580159,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsSetIamPolicy_580178 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerProjectsSetIamPolicy_580180(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerProjectsSetIamPolicy_580179(path: JsonNode;
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
  var valid_580181 = path.getOrDefault("resource")
  valid_580181 = validateParameter(valid_580181, JString, required = true,
                                 default = nil)
  if valid_580181 != nil:
    section.add "resource", valid_580181
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
  var valid_580182 = query.getOrDefault("upload_protocol")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "upload_protocol", valid_580182
  var valid_580183 = query.getOrDefault("fields")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "fields", valid_580183
  var valid_580184 = query.getOrDefault("quotaUser")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "quotaUser", valid_580184
  var valid_580185 = query.getOrDefault("alt")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = newJString("json"))
  if valid_580185 != nil:
    section.add "alt", valid_580185
  var valid_580186 = query.getOrDefault("oauth_token")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "oauth_token", valid_580186
  var valid_580187 = query.getOrDefault("callback")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "callback", valid_580187
  var valid_580188 = query.getOrDefault("access_token")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "access_token", valid_580188
  var valid_580189 = query.getOrDefault("uploadType")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "uploadType", valid_580189
  var valid_580190 = query.getOrDefault("key")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "key", valid_580190
  var valid_580191 = query.getOrDefault("$.xgafv")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = newJString("1"))
  if valid_580191 != nil:
    section.add "$.xgafv", valid_580191
  var valid_580192 = query.getOrDefault("prettyPrint")
  valid_580192 = validateParameter(valid_580192, JBool, required = false,
                                 default = newJBool(true))
  if valid_580192 != nil:
    section.add "prettyPrint", valid_580192
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

proc call*(call_580194: Call_CloudresourcemanagerProjectsSetIamPolicy_580178;
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
  let valid = call_580194.validator(path, query, header, formData, body)
  let scheme = call_580194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580194.url(scheme.get, call_580194.host, call_580194.base,
                         call_580194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580194, url, valid)

proc call*(call_580195: Call_CloudresourcemanagerProjectsSetIamPolicy_580178;
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
  var path_580196 = newJObject()
  var query_580197 = newJObject()
  var body_580198 = newJObject()
  add(query_580197, "upload_protocol", newJString(uploadProtocol))
  add(query_580197, "fields", newJString(fields))
  add(query_580197, "quotaUser", newJString(quotaUser))
  add(query_580197, "alt", newJString(alt))
  add(query_580197, "oauth_token", newJString(oauthToken))
  add(query_580197, "callback", newJString(callback))
  add(query_580197, "access_token", newJString(accessToken))
  add(query_580197, "uploadType", newJString(uploadType))
  add(query_580197, "key", newJString(key))
  add(query_580197, "$.xgafv", newJString(Xgafv))
  add(path_580196, "resource", newJString(resource))
  if body != nil:
    body_580198 = body
  add(query_580197, "prettyPrint", newJBool(prettyPrint))
  result = call_580195.call(path_580196, query_580197, nil, nil, body_580198)

var cloudresourcemanagerProjectsSetIamPolicy* = Call_CloudresourcemanagerProjectsSetIamPolicy_580178(
    name: "cloudresourcemanagerProjectsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{resource}:setIamPolicy",
    validator: validate_CloudresourcemanagerProjectsSetIamPolicy_580179,
    base: "/", url: url_CloudresourcemanagerProjectsSetIamPolicy_580180,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerProjectsTestIamPermissions_580199 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerProjectsTestIamPermissions_580201(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerProjectsTestIamPermissions_580200(
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
  var valid_580202 = path.getOrDefault("resource")
  valid_580202 = validateParameter(valid_580202, JString, required = true,
                                 default = nil)
  if valid_580202 != nil:
    section.add "resource", valid_580202
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
  var valid_580203 = query.getOrDefault("upload_protocol")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "upload_protocol", valid_580203
  var valid_580204 = query.getOrDefault("fields")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "fields", valid_580204
  var valid_580205 = query.getOrDefault("quotaUser")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "quotaUser", valid_580205
  var valid_580206 = query.getOrDefault("alt")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = newJString("json"))
  if valid_580206 != nil:
    section.add "alt", valid_580206
  var valid_580207 = query.getOrDefault("oauth_token")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "oauth_token", valid_580207
  var valid_580208 = query.getOrDefault("callback")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "callback", valid_580208
  var valid_580209 = query.getOrDefault("access_token")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "access_token", valid_580209
  var valid_580210 = query.getOrDefault("uploadType")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "uploadType", valid_580210
  var valid_580211 = query.getOrDefault("key")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "key", valid_580211
  var valid_580212 = query.getOrDefault("$.xgafv")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = newJString("1"))
  if valid_580212 != nil:
    section.add "$.xgafv", valid_580212
  var valid_580213 = query.getOrDefault("prettyPrint")
  valid_580213 = validateParameter(valid_580213, JBool, required = false,
                                 default = newJBool(true))
  if valid_580213 != nil:
    section.add "prettyPrint", valid_580213
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

proc call*(call_580215: Call_CloudresourcemanagerProjectsTestIamPermissions_580199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_580215.validator(path, query, header, formData, body)
  let scheme = call_580215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580215.url(scheme.get, call_580215.host, call_580215.base,
                         call_580215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580215, url, valid)

proc call*(call_580216: Call_CloudresourcemanagerProjectsTestIamPermissions_580199;
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
  var path_580217 = newJObject()
  var query_580218 = newJObject()
  var body_580219 = newJObject()
  add(query_580218, "upload_protocol", newJString(uploadProtocol))
  add(query_580218, "fields", newJString(fields))
  add(query_580218, "quotaUser", newJString(quotaUser))
  add(query_580218, "alt", newJString(alt))
  add(query_580218, "oauth_token", newJString(oauthToken))
  add(query_580218, "callback", newJString(callback))
  add(query_580218, "access_token", newJString(accessToken))
  add(query_580218, "uploadType", newJString(uploadType))
  add(query_580218, "key", newJString(key))
  add(query_580218, "$.xgafv", newJString(Xgafv))
  add(path_580217, "resource", newJString(resource))
  if body != nil:
    body_580219 = body
  add(query_580218, "prettyPrint", newJBool(prettyPrint))
  result = call_580216.call(path_580217, query_580218, nil, nil, body_580219)

var cloudresourcemanagerProjectsTestIamPermissions* = Call_CloudresourcemanagerProjectsTestIamPermissions_580199(
    name: "cloudresourcemanagerProjectsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/projects/{resource}:testIamPermissions",
    validator: validate_CloudresourcemanagerProjectsTestIamPermissions_580200,
    base: "/", url: url_CloudresourcemanagerProjectsTestIamPermissions_580201,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsGet_580220 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerOrganizationsGet_580222(protocol: Scheme;
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

proc validate_CloudresourcemanagerOrganizationsGet_580221(path: JsonNode;
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
  var valid_580223 = path.getOrDefault("name")
  valid_580223 = validateParameter(valid_580223, JString, required = true,
                                 default = nil)
  if valid_580223 != nil:
    section.add "name", valid_580223
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
  var valid_580224 = query.getOrDefault("upload_protocol")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "upload_protocol", valid_580224
  var valid_580225 = query.getOrDefault("fields")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "fields", valid_580225
  var valid_580226 = query.getOrDefault("quotaUser")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "quotaUser", valid_580226
  var valid_580227 = query.getOrDefault("alt")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = newJString("json"))
  if valid_580227 != nil:
    section.add "alt", valid_580227
  var valid_580228 = query.getOrDefault("oauth_token")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "oauth_token", valid_580228
  var valid_580229 = query.getOrDefault("callback")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "callback", valid_580229
  var valid_580230 = query.getOrDefault("access_token")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "access_token", valid_580230
  var valid_580231 = query.getOrDefault("uploadType")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "uploadType", valid_580231
  var valid_580232 = query.getOrDefault("key")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "key", valid_580232
  var valid_580233 = query.getOrDefault("$.xgafv")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = newJString("1"))
  if valid_580233 != nil:
    section.add "$.xgafv", valid_580233
  var valid_580234 = query.getOrDefault("prettyPrint")
  valid_580234 = validateParameter(valid_580234, JBool, required = false,
                                 default = newJBool(true))
  if valid_580234 != nil:
    section.add "prettyPrint", valid_580234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580235: Call_CloudresourcemanagerOrganizationsGet_580220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches an Organization resource identified by the specified resource name.
  ## 
  let valid = call_580235.validator(path, query, header, formData, body)
  let scheme = call_580235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580235.url(scheme.get, call_580235.host, call_580235.base,
                         call_580235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580235, url, valid)

proc call*(call_580236: Call_CloudresourcemanagerOrganizationsGet_580220;
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
  var path_580237 = newJObject()
  var query_580238 = newJObject()
  add(query_580238, "upload_protocol", newJString(uploadProtocol))
  add(query_580238, "fields", newJString(fields))
  add(query_580238, "quotaUser", newJString(quotaUser))
  add(path_580237, "name", newJString(name))
  add(query_580238, "alt", newJString(alt))
  add(query_580238, "oauth_token", newJString(oauthToken))
  add(query_580238, "callback", newJString(callback))
  add(query_580238, "access_token", newJString(accessToken))
  add(query_580238, "uploadType", newJString(uploadType))
  add(query_580238, "key", newJString(key))
  add(query_580238, "$.xgafv", newJString(Xgafv))
  add(query_580238, "prettyPrint", newJBool(prettyPrint))
  result = call_580236.call(path_580237, query_580238, nil, nil, nil)

var cloudresourcemanagerOrganizationsGet* = Call_CloudresourcemanagerOrganizationsGet_580220(
    name: "cloudresourcemanagerOrganizationsGet", meth: HttpMethod.HttpGet,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudresourcemanagerOrganizationsGet_580221, base: "/",
    url: url_CloudresourcemanagerOrganizationsGet_580222, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerLiensDelete_580239 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerLiensDelete_580241(protocol: Scheme; host: string;
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

proc validate_CloudresourcemanagerLiensDelete_580240(path: JsonNode;
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
  var valid_580242 = path.getOrDefault("name")
  valid_580242 = validateParameter(valid_580242, JString, required = true,
                                 default = nil)
  if valid_580242 != nil:
    section.add "name", valid_580242
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
  var valid_580243 = query.getOrDefault("upload_protocol")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "upload_protocol", valid_580243
  var valid_580244 = query.getOrDefault("fields")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "fields", valid_580244
  var valid_580245 = query.getOrDefault("quotaUser")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "quotaUser", valid_580245
  var valid_580246 = query.getOrDefault("alt")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = newJString("json"))
  if valid_580246 != nil:
    section.add "alt", valid_580246
  var valid_580247 = query.getOrDefault("oauth_token")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "oauth_token", valid_580247
  var valid_580248 = query.getOrDefault("callback")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "callback", valid_580248
  var valid_580249 = query.getOrDefault("access_token")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "access_token", valid_580249
  var valid_580250 = query.getOrDefault("uploadType")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "uploadType", valid_580250
  var valid_580251 = query.getOrDefault("key")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "key", valid_580251
  var valid_580252 = query.getOrDefault("$.xgafv")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = newJString("1"))
  if valid_580252 != nil:
    section.add "$.xgafv", valid_580252
  var valid_580253 = query.getOrDefault("prettyPrint")
  valid_580253 = validateParameter(valid_580253, JBool, required = false,
                                 default = newJBool(true))
  if valid_580253 != nil:
    section.add "prettyPrint", valid_580253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580254: Call_CloudresourcemanagerLiensDelete_580239;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a Lien by `name`.
  ## 
  ## Callers of this method will require permission on the `parent` resource.
  ## For example, a Lien with a `parent` of `projects/1234` requires permission
  ## `resourcemanager.projects.updateLiens`.
  ## 
  let valid = call_580254.validator(path, query, header, formData, body)
  let scheme = call_580254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580254.url(scheme.get, call_580254.host, call_580254.base,
                         call_580254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580254, url, valid)

proc call*(call_580255: Call_CloudresourcemanagerLiensDelete_580239; name: string;
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
  var path_580256 = newJObject()
  var query_580257 = newJObject()
  add(query_580257, "upload_protocol", newJString(uploadProtocol))
  add(query_580257, "fields", newJString(fields))
  add(query_580257, "quotaUser", newJString(quotaUser))
  add(path_580256, "name", newJString(name))
  add(query_580257, "alt", newJString(alt))
  add(query_580257, "oauth_token", newJString(oauthToken))
  add(query_580257, "callback", newJString(callback))
  add(query_580257, "access_token", newJString(accessToken))
  add(query_580257, "uploadType", newJString(uploadType))
  add(query_580257, "key", newJString(key))
  add(query_580257, "$.xgafv", newJString(Xgafv))
  add(query_580257, "prettyPrint", newJBool(prettyPrint))
  result = call_580255.call(path_580256, query_580257, nil, nil, nil)

var cloudresourcemanagerLiensDelete* = Call_CloudresourcemanagerLiensDelete_580239(
    name: "cloudresourcemanagerLiensDelete", meth: HttpMethod.HttpDelete,
    host: "cloudresourcemanager.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudresourcemanagerLiensDelete_580240, base: "/",
    url: url_CloudresourcemanagerLiensDelete_580241, schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsClearOrgPolicy_580258 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerOrganizationsClearOrgPolicy_580260(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerOrganizationsClearOrgPolicy_580259(
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
  var valid_580261 = path.getOrDefault("resource")
  valid_580261 = validateParameter(valid_580261, JString, required = true,
                                 default = nil)
  if valid_580261 != nil:
    section.add "resource", valid_580261
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
  var valid_580262 = query.getOrDefault("upload_protocol")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "upload_protocol", valid_580262
  var valid_580263 = query.getOrDefault("fields")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "fields", valid_580263
  var valid_580264 = query.getOrDefault("quotaUser")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "quotaUser", valid_580264
  var valid_580265 = query.getOrDefault("alt")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = newJString("json"))
  if valid_580265 != nil:
    section.add "alt", valid_580265
  var valid_580266 = query.getOrDefault("oauth_token")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "oauth_token", valid_580266
  var valid_580267 = query.getOrDefault("callback")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "callback", valid_580267
  var valid_580268 = query.getOrDefault("access_token")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "access_token", valid_580268
  var valid_580269 = query.getOrDefault("uploadType")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "uploadType", valid_580269
  var valid_580270 = query.getOrDefault("key")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "key", valid_580270
  var valid_580271 = query.getOrDefault("$.xgafv")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = newJString("1"))
  if valid_580271 != nil:
    section.add "$.xgafv", valid_580271
  var valid_580272 = query.getOrDefault("prettyPrint")
  valid_580272 = validateParameter(valid_580272, JBool, required = false,
                                 default = newJBool(true))
  if valid_580272 != nil:
    section.add "prettyPrint", valid_580272
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

proc call*(call_580274: Call_CloudresourcemanagerOrganizationsClearOrgPolicy_580258;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Clears a `Policy` from a resource.
  ## 
  let valid = call_580274.validator(path, query, header, formData, body)
  let scheme = call_580274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580274.url(scheme.get, call_580274.host, call_580274.base,
                         call_580274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580274, url, valid)

proc call*(call_580275: Call_CloudresourcemanagerOrganizationsClearOrgPolicy_580258;
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
  var path_580276 = newJObject()
  var query_580277 = newJObject()
  var body_580278 = newJObject()
  add(query_580277, "upload_protocol", newJString(uploadProtocol))
  add(query_580277, "fields", newJString(fields))
  add(query_580277, "quotaUser", newJString(quotaUser))
  add(query_580277, "alt", newJString(alt))
  add(query_580277, "oauth_token", newJString(oauthToken))
  add(query_580277, "callback", newJString(callback))
  add(query_580277, "access_token", newJString(accessToken))
  add(query_580277, "uploadType", newJString(uploadType))
  add(query_580277, "key", newJString(key))
  add(query_580277, "$.xgafv", newJString(Xgafv))
  add(path_580276, "resource", newJString(resource))
  if body != nil:
    body_580278 = body
  add(query_580277, "prettyPrint", newJBool(prettyPrint))
  result = call_580275.call(path_580276, query_580277, nil, nil, body_580278)

var cloudresourcemanagerOrganizationsClearOrgPolicy* = Call_CloudresourcemanagerOrganizationsClearOrgPolicy_580258(
    name: "cloudresourcemanagerOrganizationsClearOrgPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:clearOrgPolicy",
    validator: validate_CloudresourcemanagerOrganizationsClearOrgPolicy_580259,
    base: "/", url: url_CloudresourcemanagerOrganizationsClearOrgPolicy_580260,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_580279 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_580281(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_580280(
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
  var valid_580282 = path.getOrDefault("resource")
  valid_580282 = validateParameter(valid_580282, JString, required = true,
                                 default = nil)
  if valid_580282 != nil:
    section.add "resource", valid_580282
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
  var valid_580283 = query.getOrDefault("upload_protocol")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "upload_protocol", valid_580283
  var valid_580284 = query.getOrDefault("fields")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "fields", valid_580284
  var valid_580285 = query.getOrDefault("quotaUser")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "quotaUser", valid_580285
  var valid_580286 = query.getOrDefault("alt")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = newJString("json"))
  if valid_580286 != nil:
    section.add "alt", valid_580286
  var valid_580287 = query.getOrDefault("oauth_token")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "oauth_token", valid_580287
  var valid_580288 = query.getOrDefault("callback")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "callback", valid_580288
  var valid_580289 = query.getOrDefault("access_token")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "access_token", valid_580289
  var valid_580290 = query.getOrDefault("uploadType")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "uploadType", valid_580290
  var valid_580291 = query.getOrDefault("key")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "key", valid_580291
  var valid_580292 = query.getOrDefault("$.xgafv")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = newJString("1"))
  if valid_580292 != nil:
    section.add "$.xgafv", valid_580292
  var valid_580293 = query.getOrDefault("prettyPrint")
  valid_580293 = validateParameter(valid_580293, JBool, required = false,
                                 default = newJBool(true))
  if valid_580293 != nil:
    section.add "prettyPrint", valid_580293
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

proc call*(call_580295: Call_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_580279;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the effective `Policy` on a resource. This is the result of merging
  ## `Policies` in the resource hierarchy. The returned `Policy` will not have
  ## an `etag`set because it is a computed `Policy` across multiple resources.
  ## Subtrees of Resource Manager resource hierarchy with 'under:' prefix will
  ## not be expanded.
  ## 
  let valid = call_580295.validator(path, query, header, formData, body)
  let scheme = call_580295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580295.url(scheme.get, call_580295.host, call_580295.base,
                         call_580295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580295, url, valid)

proc call*(call_580296: Call_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_580279;
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
  var path_580297 = newJObject()
  var query_580298 = newJObject()
  var body_580299 = newJObject()
  add(query_580298, "upload_protocol", newJString(uploadProtocol))
  add(query_580298, "fields", newJString(fields))
  add(query_580298, "quotaUser", newJString(quotaUser))
  add(query_580298, "alt", newJString(alt))
  add(query_580298, "oauth_token", newJString(oauthToken))
  add(query_580298, "callback", newJString(callback))
  add(query_580298, "access_token", newJString(accessToken))
  add(query_580298, "uploadType", newJString(uploadType))
  add(query_580298, "key", newJString(key))
  add(query_580298, "$.xgafv", newJString(Xgafv))
  add(path_580297, "resource", newJString(resource))
  if body != nil:
    body_580299 = body
  add(query_580298, "prettyPrint", newJBool(prettyPrint))
  result = call_580296.call(path_580297, query_580298, nil, nil, body_580299)

var cloudresourcemanagerOrganizationsGetEffectiveOrgPolicy* = Call_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_580279(
    name: "cloudresourcemanagerOrganizationsGetEffectiveOrgPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:getEffectiveOrgPolicy",
    validator: validate_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_580280,
    base: "/", url: url_CloudresourcemanagerOrganizationsGetEffectiveOrgPolicy_580281,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsGetIamPolicy_580300 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerOrganizationsGetIamPolicy_580302(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerOrganizationsGetIamPolicy_580301(
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
  var valid_580303 = path.getOrDefault("resource")
  valid_580303 = validateParameter(valid_580303, JString, required = true,
                                 default = nil)
  if valid_580303 != nil:
    section.add "resource", valid_580303
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
  var valid_580304 = query.getOrDefault("upload_protocol")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "upload_protocol", valid_580304
  var valid_580305 = query.getOrDefault("fields")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "fields", valid_580305
  var valid_580306 = query.getOrDefault("quotaUser")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "quotaUser", valid_580306
  var valid_580307 = query.getOrDefault("alt")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = newJString("json"))
  if valid_580307 != nil:
    section.add "alt", valid_580307
  var valid_580308 = query.getOrDefault("oauth_token")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "oauth_token", valid_580308
  var valid_580309 = query.getOrDefault("callback")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "callback", valid_580309
  var valid_580310 = query.getOrDefault("access_token")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "access_token", valid_580310
  var valid_580311 = query.getOrDefault("uploadType")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "uploadType", valid_580311
  var valid_580312 = query.getOrDefault("key")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "key", valid_580312
  var valid_580313 = query.getOrDefault("$.xgafv")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = newJString("1"))
  if valid_580313 != nil:
    section.add "$.xgafv", valid_580313
  var valid_580314 = query.getOrDefault("prettyPrint")
  valid_580314 = validateParameter(valid_580314, JBool, required = false,
                                 default = newJBool(true))
  if valid_580314 != nil:
    section.add "prettyPrint", valid_580314
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

proc call*(call_580316: Call_CloudresourcemanagerOrganizationsGetIamPolicy_580300;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for an Organization resource. May be empty
  ## if no such policy or resource exists. The `resource` field should be the
  ## organization's resource name, e.g. "organizations/123".
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.organizations.getIamPolicy` on the specified organization
  ## 
  let valid = call_580316.validator(path, query, header, formData, body)
  let scheme = call_580316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580316.url(scheme.get, call_580316.host, call_580316.base,
                         call_580316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580316, url, valid)

proc call*(call_580317: Call_CloudresourcemanagerOrganizationsGetIamPolicy_580300;
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
  var path_580318 = newJObject()
  var query_580319 = newJObject()
  var body_580320 = newJObject()
  add(query_580319, "upload_protocol", newJString(uploadProtocol))
  add(query_580319, "fields", newJString(fields))
  add(query_580319, "quotaUser", newJString(quotaUser))
  add(query_580319, "alt", newJString(alt))
  add(query_580319, "oauth_token", newJString(oauthToken))
  add(query_580319, "callback", newJString(callback))
  add(query_580319, "access_token", newJString(accessToken))
  add(query_580319, "uploadType", newJString(uploadType))
  add(query_580319, "key", newJString(key))
  add(query_580319, "$.xgafv", newJString(Xgafv))
  add(path_580318, "resource", newJString(resource))
  if body != nil:
    body_580320 = body
  add(query_580319, "prettyPrint", newJBool(prettyPrint))
  result = call_580317.call(path_580318, query_580319, nil, nil, body_580320)

var cloudresourcemanagerOrganizationsGetIamPolicy* = Call_CloudresourcemanagerOrganizationsGetIamPolicy_580300(
    name: "cloudresourcemanagerOrganizationsGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_CloudresourcemanagerOrganizationsGetIamPolicy_580301,
    base: "/", url: url_CloudresourcemanagerOrganizationsGetIamPolicy_580302,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsGetOrgPolicy_580321 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerOrganizationsGetOrgPolicy_580323(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerOrganizationsGetOrgPolicy_580322(
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
  var valid_580324 = path.getOrDefault("resource")
  valid_580324 = validateParameter(valid_580324, JString, required = true,
                                 default = nil)
  if valid_580324 != nil:
    section.add "resource", valid_580324
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
  var valid_580325 = query.getOrDefault("upload_protocol")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "upload_protocol", valid_580325
  var valid_580326 = query.getOrDefault("fields")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "fields", valid_580326
  var valid_580327 = query.getOrDefault("quotaUser")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "quotaUser", valid_580327
  var valid_580328 = query.getOrDefault("alt")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = newJString("json"))
  if valid_580328 != nil:
    section.add "alt", valid_580328
  var valid_580329 = query.getOrDefault("oauth_token")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "oauth_token", valid_580329
  var valid_580330 = query.getOrDefault("callback")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "callback", valid_580330
  var valid_580331 = query.getOrDefault("access_token")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "access_token", valid_580331
  var valid_580332 = query.getOrDefault("uploadType")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "uploadType", valid_580332
  var valid_580333 = query.getOrDefault("key")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "key", valid_580333
  var valid_580334 = query.getOrDefault("$.xgafv")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = newJString("1"))
  if valid_580334 != nil:
    section.add "$.xgafv", valid_580334
  var valid_580335 = query.getOrDefault("prettyPrint")
  valid_580335 = validateParameter(valid_580335, JBool, required = false,
                                 default = newJBool(true))
  if valid_580335 != nil:
    section.add "prettyPrint", valid_580335
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

proc call*(call_580337: Call_CloudresourcemanagerOrganizationsGetOrgPolicy_580321;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a `Policy` on a resource.
  ## 
  ## If no `Policy` is set on the resource, a `Policy` is returned with default
  ## values including `POLICY_TYPE_NOT_SET` for the `policy_type oneof`. The
  ## `etag` value can be used with `SetOrgPolicy()` to create or update a
  ## `Policy` during read-modify-write.
  ## 
  let valid = call_580337.validator(path, query, header, formData, body)
  let scheme = call_580337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580337.url(scheme.get, call_580337.host, call_580337.base,
                         call_580337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580337, url, valid)

proc call*(call_580338: Call_CloudresourcemanagerOrganizationsGetOrgPolicy_580321;
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
  var path_580339 = newJObject()
  var query_580340 = newJObject()
  var body_580341 = newJObject()
  add(query_580340, "upload_protocol", newJString(uploadProtocol))
  add(query_580340, "fields", newJString(fields))
  add(query_580340, "quotaUser", newJString(quotaUser))
  add(query_580340, "alt", newJString(alt))
  add(query_580340, "oauth_token", newJString(oauthToken))
  add(query_580340, "callback", newJString(callback))
  add(query_580340, "access_token", newJString(accessToken))
  add(query_580340, "uploadType", newJString(uploadType))
  add(query_580340, "key", newJString(key))
  add(query_580340, "$.xgafv", newJString(Xgafv))
  add(path_580339, "resource", newJString(resource))
  if body != nil:
    body_580341 = body
  add(query_580340, "prettyPrint", newJBool(prettyPrint))
  result = call_580338.call(path_580339, query_580340, nil, nil, body_580341)

var cloudresourcemanagerOrganizationsGetOrgPolicy* = Call_CloudresourcemanagerOrganizationsGetOrgPolicy_580321(
    name: "cloudresourcemanagerOrganizationsGetOrgPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:getOrgPolicy",
    validator: validate_CloudresourcemanagerOrganizationsGetOrgPolicy_580322,
    base: "/", url: url_CloudresourcemanagerOrganizationsGetOrgPolicy_580323,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_580342 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_580344(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_580343(
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
  var valid_580345 = path.getOrDefault("resource")
  valid_580345 = validateParameter(valid_580345, JString, required = true,
                                 default = nil)
  if valid_580345 != nil:
    section.add "resource", valid_580345
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
  var valid_580346 = query.getOrDefault("upload_protocol")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "upload_protocol", valid_580346
  var valid_580347 = query.getOrDefault("fields")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "fields", valid_580347
  var valid_580348 = query.getOrDefault("quotaUser")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "quotaUser", valid_580348
  var valid_580349 = query.getOrDefault("alt")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = newJString("json"))
  if valid_580349 != nil:
    section.add "alt", valid_580349
  var valid_580350 = query.getOrDefault("oauth_token")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "oauth_token", valid_580350
  var valid_580351 = query.getOrDefault("callback")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "callback", valid_580351
  var valid_580352 = query.getOrDefault("access_token")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "access_token", valid_580352
  var valid_580353 = query.getOrDefault("uploadType")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "uploadType", valid_580353
  var valid_580354 = query.getOrDefault("key")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "key", valid_580354
  var valid_580355 = query.getOrDefault("$.xgafv")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = newJString("1"))
  if valid_580355 != nil:
    section.add "$.xgafv", valid_580355
  var valid_580356 = query.getOrDefault("prettyPrint")
  valid_580356 = validateParameter(valid_580356, JBool, required = false,
                                 default = newJBool(true))
  if valid_580356 != nil:
    section.add "prettyPrint", valid_580356
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

proc call*(call_580358: Call_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_580342;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists `Constraints` that could be applied on the specified resource.
  ## 
  let valid = call_580358.validator(path, query, header, formData, body)
  let scheme = call_580358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580358.url(scheme.get, call_580358.host, call_580358.base,
                         call_580358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580358, url, valid)

proc call*(call_580359: Call_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_580342;
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
  var path_580360 = newJObject()
  var query_580361 = newJObject()
  var body_580362 = newJObject()
  add(query_580361, "upload_protocol", newJString(uploadProtocol))
  add(query_580361, "fields", newJString(fields))
  add(query_580361, "quotaUser", newJString(quotaUser))
  add(query_580361, "alt", newJString(alt))
  add(query_580361, "oauth_token", newJString(oauthToken))
  add(query_580361, "callback", newJString(callback))
  add(query_580361, "access_token", newJString(accessToken))
  add(query_580361, "uploadType", newJString(uploadType))
  add(query_580361, "key", newJString(key))
  add(query_580361, "$.xgafv", newJString(Xgafv))
  add(path_580360, "resource", newJString(resource))
  if body != nil:
    body_580362 = body
  add(query_580361, "prettyPrint", newJBool(prettyPrint))
  result = call_580359.call(path_580360, query_580361, nil, nil, body_580362)

var cloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints* = Call_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_580342(
    name: "cloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:listAvailableOrgPolicyConstraints", validator: validate_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_580343,
    base: "/", url: url_CloudresourcemanagerOrganizationsListAvailableOrgPolicyConstraints_580344,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsListOrgPolicies_580363 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerOrganizationsListOrgPolicies_580365(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerOrganizationsListOrgPolicies_580364(
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
  var valid_580366 = path.getOrDefault("resource")
  valid_580366 = validateParameter(valid_580366, JString, required = true,
                                 default = nil)
  if valid_580366 != nil:
    section.add "resource", valid_580366
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
  var valid_580367 = query.getOrDefault("upload_protocol")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "upload_protocol", valid_580367
  var valid_580368 = query.getOrDefault("fields")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "fields", valid_580368
  var valid_580369 = query.getOrDefault("quotaUser")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "quotaUser", valid_580369
  var valid_580370 = query.getOrDefault("alt")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = newJString("json"))
  if valid_580370 != nil:
    section.add "alt", valid_580370
  var valid_580371 = query.getOrDefault("oauth_token")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "oauth_token", valid_580371
  var valid_580372 = query.getOrDefault("callback")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "callback", valid_580372
  var valid_580373 = query.getOrDefault("access_token")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "access_token", valid_580373
  var valid_580374 = query.getOrDefault("uploadType")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "uploadType", valid_580374
  var valid_580375 = query.getOrDefault("key")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "key", valid_580375
  var valid_580376 = query.getOrDefault("$.xgafv")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = newJString("1"))
  if valid_580376 != nil:
    section.add "$.xgafv", valid_580376
  var valid_580377 = query.getOrDefault("prettyPrint")
  valid_580377 = validateParameter(valid_580377, JBool, required = false,
                                 default = newJBool(true))
  if valid_580377 != nil:
    section.add "prettyPrint", valid_580377
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

proc call*(call_580379: Call_CloudresourcemanagerOrganizationsListOrgPolicies_580363;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the `Policies` set for a particular resource.
  ## 
  let valid = call_580379.validator(path, query, header, formData, body)
  let scheme = call_580379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580379.url(scheme.get, call_580379.host, call_580379.base,
                         call_580379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580379, url, valid)

proc call*(call_580380: Call_CloudresourcemanagerOrganizationsListOrgPolicies_580363;
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
  var path_580381 = newJObject()
  var query_580382 = newJObject()
  var body_580383 = newJObject()
  add(query_580382, "upload_protocol", newJString(uploadProtocol))
  add(query_580382, "fields", newJString(fields))
  add(query_580382, "quotaUser", newJString(quotaUser))
  add(query_580382, "alt", newJString(alt))
  add(query_580382, "oauth_token", newJString(oauthToken))
  add(query_580382, "callback", newJString(callback))
  add(query_580382, "access_token", newJString(accessToken))
  add(query_580382, "uploadType", newJString(uploadType))
  add(query_580382, "key", newJString(key))
  add(query_580382, "$.xgafv", newJString(Xgafv))
  add(path_580381, "resource", newJString(resource))
  if body != nil:
    body_580383 = body
  add(query_580382, "prettyPrint", newJBool(prettyPrint))
  result = call_580380.call(path_580381, query_580382, nil, nil, body_580383)

var cloudresourcemanagerOrganizationsListOrgPolicies* = Call_CloudresourcemanagerOrganizationsListOrgPolicies_580363(
    name: "cloudresourcemanagerOrganizationsListOrgPolicies",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:listOrgPolicies",
    validator: validate_CloudresourcemanagerOrganizationsListOrgPolicies_580364,
    base: "/", url: url_CloudresourcemanagerOrganizationsListOrgPolicies_580365,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsSetIamPolicy_580384 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerOrganizationsSetIamPolicy_580386(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerOrganizationsSetIamPolicy_580385(
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
  var valid_580387 = path.getOrDefault("resource")
  valid_580387 = validateParameter(valid_580387, JString, required = true,
                                 default = nil)
  if valid_580387 != nil:
    section.add "resource", valid_580387
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
  var valid_580388 = query.getOrDefault("upload_protocol")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "upload_protocol", valid_580388
  var valid_580389 = query.getOrDefault("fields")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "fields", valid_580389
  var valid_580390 = query.getOrDefault("quotaUser")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "quotaUser", valid_580390
  var valid_580391 = query.getOrDefault("alt")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = newJString("json"))
  if valid_580391 != nil:
    section.add "alt", valid_580391
  var valid_580392 = query.getOrDefault("oauth_token")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "oauth_token", valid_580392
  var valid_580393 = query.getOrDefault("callback")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "callback", valid_580393
  var valid_580394 = query.getOrDefault("access_token")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "access_token", valid_580394
  var valid_580395 = query.getOrDefault("uploadType")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "uploadType", valid_580395
  var valid_580396 = query.getOrDefault("key")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "key", valid_580396
  var valid_580397 = query.getOrDefault("$.xgafv")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = newJString("1"))
  if valid_580397 != nil:
    section.add "$.xgafv", valid_580397
  var valid_580398 = query.getOrDefault("prettyPrint")
  valid_580398 = validateParameter(valid_580398, JBool, required = false,
                                 default = newJBool(true))
  if valid_580398 != nil:
    section.add "prettyPrint", valid_580398
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

proc call*(call_580400: Call_CloudresourcemanagerOrganizationsSetIamPolicy_580384;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on an Organization resource. Replaces any
  ## existing policy. The `resource` field should be the organization's resource
  ## name, e.g. "organizations/123".
  ## 
  ## Authorization requires the Google IAM permission
  ## `resourcemanager.organizations.setIamPolicy` on the specified organization
  ## 
  let valid = call_580400.validator(path, query, header, formData, body)
  let scheme = call_580400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580400.url(scheme.get, call_580400.host, call_580400.base,
                         call_580400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580400, url, valid)

proc call*(call_580401: Call_CloudresourcemanagerOrganizationsSetIamPolicy_580384;
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
  var path_580402 = newJObject()
  var query_580403 = newJObject()
  var body_580404 = newJObject()
  add(query_580403, "upload_protocol", newJString(uploadProtocol))
  add(query_580403, "fields", newJString(fields))
  add(query_580403, "quotaUser", newJString(quotaUser))
  add(query_580403, "alt", newJString(alt))
  add(query_580403, "oauth_token", newJString(oauthToken))
  add(query_580403, "callback", newJString(callback))
  add(query_580403, "access_token", newJString(accessToken))
  add(query_580403, "uploadType", newJString(uploadType))
  add(query_580403, "key", newJString(key))
  add(query_580403, "$.xgafv", newJString(Xgafv))
  add(path_580402, "resource", newJString(resource))
  if body != nil:
    body_580404 = body
  add(query_580403, "prettyPrint", newJBool(prettyPrint))
  result = call_580401.call(path_580402, query_580403, nil, nil, body_580404)

var cloudresourcemanagerOrganizationsSetIamPolicy* = Call_CloudresourcemanagerOrganizationsSetIamPolicy_580384(
    name: "cloudresourcemanagerOrganizationsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_CloudresourcemanagerOrganizationsSetIamPolicy_580385,
    base: "/", url: url_CloudresourcemanagerOrganizationsSetIamPolicy_580386,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsSetOrgPolicy_580405 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerOrganizationsSetOrgPolicy_580407(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerOrganizationsSetOrgPolicy_580406(
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
  var valid_580408 = path.getOrDefault("resource")
  valid_580408 = validateParameter(valid_580408, JString, required = true,
                                 default = nil)
  if valid_580408 != nil:
    section.add "resource", valid_580408
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
  var valid_580409 = query.getOrDefault("upload_protocol")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "upload_protocol", valid_580409
  var valid_580410 = query.getOrDefault("fields")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "fields", valid_580410
  var valid_580411 = query.getOrDefault("quotaUser")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "quotaUser", valid_580411
  var valid_580412 = query.getOrDefault("alt")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = newJString("json"))
  if valid_580412 != nil:
    section.add "alt", valid_580412
  var valid_580413 = query.getOrDefault("oauth_token")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "oauth_token", valid_580413
  var valid_580414 = query.getOrDefault("callback")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "callback", valid_580414
  var valid_580415 = query.getOrDefault("access_token")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "access_token", valid_580415
  var valid_580416 = query.getOrDefault("uploadType")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "uploadType", valid_580416
  var valid_580417 = query.getOrDefault("key")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "key", valid_580417
  var valid_580418 = query.getOrDefault("$.xgafv")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = newJString("1"))
  if valid_580418 != nil:
    section.add "$.xgafv", valid_580418
  var valid_580419 = query.getOrDefault("prettyPrint")
  valid_580419 = validateParameter(valid_580419, JBool, required = false,
                                 default = newJBool(true))
  if valid_580419 != nil:
    section.add "prettyPrint", valid_580419
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

proc call*(call_580421: Call_CloudresourcemanagerOrganizationsSetOrgPolicy_580405;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified `Policy` on the resource. Creates a new `Policy` for
  ## that `Constraint` on the resource if one does not exist.
  ## 
  ## Not supplying an `etag` on the request `Policy` results in an unconditional
  ## write of the `Policy`.
  ## 
  let valid = call_580421.validator(path, query, header, formData, body)
  let scheme = call_580421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580421.url(scheme.get, call_580421.host, call_580421.base,
                         call_580421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580421, url, valid)

proc call*(call_580422: Call_CloudresourcemanagerOrganizationsSetOrgPolicy_580405;
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
  var path_580423 = newJObject()
  var query_580424 = newJObject()
  var body_580425 = newJObject()
  add(query_580424, "upload_protocol", newJString(uploadProtocol))
  add(query_580424, "fields", newJString(fields))
  add(query_580424, "quotaUser", newJString(quotaUser))
  add(query_580424, "alt", newJString(alt))
  add(query_580424, "oauth_token", newJString(oauthToken))
  add(query_580424, "callback", newJString(callback))
  add(query_580424, "access_token", newJString(accessToken))
  add(query_580424, "uploadType", newJString(uploadType))
  add(query_580424, "key", newJString(key))
  add(query_580424, "$.xgafv", newJString(Xgafv))
  add(path_580423, "resource", newJString(resource))
  if body != nil:
    body_580425 = body
  add(query_580424, "prettyPrint", newJBool(prettyPrint))
  result = call_580422.call(path_580423, query_580424, nil, nil, body_580425)

var cloudresourcemanagerOrganizationsSetOrgPolicy* = Call_CloudresourcemanagerOrganizationsSetOrgPolicy_580405(
    name: "cloudresourcemanagerOrganizationsSetOrgPolicy",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:setOrgPolicy",
    validator: validate_CloudresourcemanagerOrganizationsSetOrgPolicy_580406,
    base: "/", url: url_CloudresourcemanagerOrganizationsSetOrgPolicy_580407,
    schemes: {Scheme.Https})
type
  Call_CloudresourcemanagerOrganizationsTestIamPermissions_580426 = ref object of OpenApiRestCall_579421
proc url_CloudresourcemanagerOrganizationsTestIamPermissions_580428(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_CloudresourcemanagerOrganizationsTestIamPermissions_580427(
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
  var valid_580429 = path.getOrDefault("resource")
  valid_580429 = validateParameter(valid_580429, JString, required = true,
                                 default = nil)
  if valid_580429 != nil:
    section.add "resource", valid_580429
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
  var valid_580430 = query.getOrDefault("upload_protocol")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "upload_protocol", valid_580430
  var valid_580431 = query.getOrDefault("fields")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "fields", valid_580431
  var valid_580432 = query.getOrDefault("quotaUser")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "quotaUser", valid_580432
  var valid_580433 = query.getOrDefault("alt")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = newJString("json"))
  if valid_580433 != nil:
    section.add "alt", valid_580433
  var valid_580434 = query.getOrDefault("oauth_token")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "oauth_token", valid_580434
  var valid_580435 = query.getOrDefault("callback")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "callback", valid_580435
  var valid_580436 = query.getOrDefault("access_token")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "access_token", valid_580436
  var valid_580437 = query.getOrDefault("uploadType")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "uploadType", valid_580437
  var valid_580438 = query.getOrDefault("key")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = nil)
  if valid_580438 != nil:
    section.add "key", valid_580438
  var valid_580439 = query.getOrDefault("$.xgafv")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = newJString("1"))
  if valid_580439 != nil:
    section.add "$.xgafv", valid_580439
  var valid_580440 = query.getOrDefault("prettyPrint")
  valid_580440 = validateParameter(valid_580440, JBool, required = false,
                                 default = newJBool(true))
  if valid_580440 != nil:
    section.add "prettyPrint", valid_580440
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

proc call*(call_580442: Call_CloudresourcemanagerOrganizationsTestIamPermissions_580426;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Organization.
  ## The `resource` field should be the organization's resource name,
  ## e.g. "organizations/123".
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_580442.validator(path, query, header, formData, body)
  let scheme = call_580442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580442.url(scheme.get, call_580442.host, call_580442.base,
                         call_580442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580442, url, valid)

proc call*(call_580443: Call_CloudresourcemanagerOrganizationsTestIamPermissions_580426;
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
  var path_580444 = newJObject()
  var query_580445 = newJObject()
  var body_580446 = newJObject()
  add(query_580445, "upload_protocol", newJString(uploadProtocol))
  add(query_580445, "fields", newJString(fields))
  add(query_580445, "quotaUser", newJString(quotaUser))
  add(query_580445, "alt", newJString(alt))
  add(query_580445, "oauth_token", newJString(oauthToken))
  add(query_580445, "callback", newJString(callback))
  add(query_580445, "access_token", newJString(accessToken))
  add(query_580445, "uploadType", newJString(uploadType))
  add(query_580445, "key", newJString(key))
  add(query_580445, "$.xgafv", newJString(Xgafv))
  add(path_580444, "resource", newJString(resource))
  if body != nil:
    body_580446 = body
  add(query_580445, "prettyPrint", newJBool(prettyPrint))
  result = call_580443.call(path_580444, query_580445, nil, nil, body_580446)

var cloudresourcemanagerOrganizationsTestIamPermissions* = Call_CloudresourcemanagerOrganizationsTestIamPermissions_580426(
    name: "cloudresourcemanagerOrganizationsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudresourcemanager.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_CloudresourcemanagerOrganizationsTestIamPermissions_580427,
    base: "/", url: url_CloudresourcemanagerOrganizationsTestIamPermissions_580428,
    schemes: {Scheme.Https})
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
