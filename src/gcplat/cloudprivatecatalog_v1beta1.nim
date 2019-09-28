
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Private Catalog
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Enable cloud users to discover enterprise catalogs and products in their organizations.
## 
## https://cloud.google.com/private-catalog/
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
  gcpServiceName = "cloudprivatecatalog"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudprivatecatalogOrganizationsCatalogsSearch_579677 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogOrganizationsCatalogsSearch_579679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/catalogs:search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogOrganizationsCatalogsSearch_579678(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Search Catalog resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Required. The name of the resource context. It can be in following formats:
  ## 
  ## * `projects/{project_id}`
  ## * `folders/{folder_id}`
  ## * `organizations/{organization_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579805 = path.getOrDefault("resource")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "resource", valid_579805
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to SearchCatalogs that
  ## indicates where this listing should continue from.
  ## This field is optional.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   query: JString
  ##        : The query to filter the catalogs. The supported queries are:
  ## 
  ## * Get a single catalog: `name=catalogs/{catalog_id}`
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
  ##           : The maximum number of entries that are requested.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579806 = query.getOrDefault("upload_protocol")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "upload_protocol", valid_579806
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  var valid_579808 = query.getOrDefault("pageToken")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "pageToken", valid_579808
  var valid_579809 = query.getOrDefault("quotaUser")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "quotaUser", valid_579809
  var valid_579823 = query.getOrDefault("alt")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = newJString("json"))
  if valid_579823 != nil:
    section.add "alt", valid_579823
  var valid_579824 = query.getOrDefault("query")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "query", valid_579824
  var valid_579825 = query.getOrDefault("oauth_token")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "oauth_token", valid_579825
  var valid_579826 = query.getOrDefault("callback")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "callback", valid_579826
  var valid_579827 = query.getOrDefault("access_token")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "access_token", valid_579827
  var valid_579828 = query.getOrDefault("uploadType")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "uploadType", valid_579828
  var valid_579829 = query.getOrDefault("key")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = nil)
  if valid_579829 != nil:
    section.add "key", valid_579829
  var valid_579830 = query.getOrDefault("$.xgafv")
  valid_579830 = validateParameter(valid_579830, JString, required = false,
                                 default = newJString("1"))
  if valid_579830 != nil:
    section.add "$.xgafv", valid_579830
  var valid_579831 = query.getOrDefault("pageSize")
  valid_579831 = validateParameter(valid_579831, JInt, required = false, default = nil)
  if valid_579831 != nil:
    section.add "pageSize", valid_579831
  var valid_579832 = query.getOrDefault("prettyPrint")
  valid_579832 = validateParameter(valid_579832, JBool, required = false,
                                 default = newJBool(true))
  if valid_579832 != nil:
    section.add "prettyPrint", valid_579832
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579855: Call_CloudprivatecatalogOrganizationsCatalogsSearch_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search Catalog resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  let valid = call_579855.validator(path, query, header, formData, body)
  let scheme = call_579855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579855.url(scheme.get, call_579855.host, call_579855.base,
                         call_579855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579855, url, valid)

proc call*(call_579926: Call_CloudprivatecatalogOrganizationsCatalogsSearch_579677;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          query: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogOrganizationsCatalogsSearch
  ## Search Catalog resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to SearchCatalogs that
  ## indicates where this listing should continue from.
  ## This field is optional.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : The query to filter the catalogs. The supported queries are:
  ## 
  ## * Get a single catalog: `name=catalogs/{catalog_id}`
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
  ##           : Required. The name of the resource context. It can be in following formats:
  ## 
  ## * `projects/{project_id}`
  ## * `folders/{folder_id}`
  ## * `organizations/{organization_id}`
  ##   pageSize: int
  ##           : The maximum number of entries that are requested.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579927 = newJObject()
  var query_579929 = newJObject()
  add(query_579929, "upload_protocol", newJString(uploadProtocol))
  add(query_579929, "fields", newJString(fields))
  add(query_579929, "pageToken", newJString(pageToken))
  add(query_579929, "quotaUser", newJString(quotaUser))
  add(query_579929, "alt", newJString(alt))
  add(query_579929, "query", newJString(query))
  add(query_579929, "oauth_token", newJString(oauthToken))
  add(query_579929, "callback", newJString(callback))
  add(query_579929, "access_token", newJString(accessToken))
  add(query_579929, "uploadType", newJString(uploadType))
  add(query_579929, "key", newJString(key))
  add(query_579929, "$.xgafv", newJString(Xgafv))
  add(path_579927, "resource", newJString(resource))
  add(query_579929, "pageSize", newJInt(pageSize))
  add(query_579929, "prettyPrint", newJBool(prettyPrint))
  result = call_579926.call(path_579927, query_579929, nil, nil, nil)

var cloudprivatecatalogOrganizationsCatalogsSearch* = Call_CloudprivatecatalogOrganizationsCatalogsSearch_579677(
    name: "cloudprivatecatalogOrganizationsCatalogsSearch",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalog.googleapis.com",
    route: "/v1beta1/{resource}/catalogs:search",
    validator: validate_CloudprivatecatalogOrganizationsCatalogsSearch_579678,
    base: "/", url: url_CloudprivatecatalogOrganizationsCatalogsSearch_579679,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogOrganizationsProductsSearch_579968 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogOrganizationsProductsSearch_579970(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/products:search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogOrganizationsProductsSearch_579969(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Search Product resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Required. The name of the resource context. See
  ## SearchCatalogsRequest.resource for details.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579971 = path.getOrDefault("resource")
  valid_579971 = validateParameter(valid_579971, JString, required = true,
                                 default = nil)
  if valid_579971 != nil:
    section.add "resource", valid_579971
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to SearchProducts that
  ## indicates where this listing should continue from.
  ## This field is optional.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   query: JString
  ##        : The query to filter the products.
  ## 
  ## The supported queries are:
  ## * List products of all catalogs: empty
  ## * List products under a catalog: `parent=catalogs/{catalog_id}`
  ## * Get a product by name:
  ## `name=catalogs/{catalog_id}/products/{product_id}`
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
  ##           : The maximum number of entries that are requested.
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
  var valid_579974 = query.getOrDefault("pageToken")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "pageToken", valid_579974
  var valid_579975 = query.getOrDefault("quotaUser")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "quotaUser", valid_579975
  var valid_579976 = query.getOrDefault("alt")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = newJString("json"))
  if valid_579976 != nil:
    section.add "alt", valid_579976
  var valid_579977 = query.getOrDefault("query")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "query", valid_579977
  var valid_579978 = query.getOrDefault("oauth_token")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "oauth_token", valid_579978
  var valid_579979 = query.getOrDefault("callback")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "callback", valid_579979
  var valid_579980 = query.getOrDefault("access_token")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "access_token", valid_579980
  var valid_579981 = query.getOrDefault("uploadType")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "uploadType", valid_579981
  var valid_579982 = query.getOrDefault("key")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "key", valid_579982
  var valid_579983 = query.getOrDefault("$.xgafv")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = newJString("1"))
  if valid_579983 != nil:
    section.add "$.xgafv", valid_579983
  var valid_579984 = query.getOrDefault("pageSize")
  valid_579984 = validateParameter(valid_579984, JInt, required = false, default = nil)
  if valid_579984 != nil:
    section.add "pageSize", valid_579984
  var valid_579985 = query.getOrDefault("prettyPrint")
  valid_579985 = validateParameter(valid_579985, JBool, required = false,
                                 default = newJBool(true))
  if valid_579985 != nil:
    section.add "prettyPrint", valid_579985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579986: Call_CloudprivatecatalogOrganizationsProductsSearch_579968;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search Product resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  let valid = call_579986.validator(path, query, header, formData, body)
  let scheme = call_579986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579986.url(scheme.get, call_579986.host, call_579986.base,
                         call_579986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579986, url, valid)

proc call*(call_579987: Call_CloudprivatecatalogOrganizationsProductsSearch_579968;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          query: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogOrganizationsProductsSearch
  ## Search Product resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to SearchProducts that
  ## indicates where this listing should continue from.
  ## This field is optional.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : The query to filter the products.
  ## 
  ## The supported queries are:
  ## * List products of all catalogs: empty
  ## * List products under a catalog: `parent=catalogs/{catalog_id}`
  ## * Get a product by name:
  ## `name=catalogs/{catalog_id}/products/{product_id}`
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
  ##           : Required. The name of the resource context. See
  ## SearchCatalogsRequest.resource for details.
  ##   pageSize: int
  ##           : The maximum number of entries that are requested.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579988 = newJObject()
  var query_579989 = newJObject()
  add(query_579989, "upload_protocol", newJString(uploadProtocol))
  add(query_579989, "fields", newJString(fields))
  add(query_579989, "pageToken", newJString(pageToken))
  add(query_579989, "quotaUser", newJString(quotaUser))
  add(query_579989, "alt", newJString(alt))
  add(query_579989, "query", newJString(query))
  add(query_579989, "oauth_token", newJString(oauthToken))
  add(query_579989, "callback", newJString(callback))
  add(query_579989, "access_token", newJString(accessToken))
  add(query_579989, "uploadType", newJString(uploadType))
  add(query_579989, "key", newJString(key))
  add(query_579989, "$.xgafv", newJString(Xgafv))
  add(path_579988, "resource", newJString(resource))
  add(query_579989, "pageSize", newJInt(pageSize))
  add(query_579989, "prettyPrint", newJBool(prettyPrint))
  result = call_579987.call(path_579988, query_579989, nil, nil, nil)

var cloudprivatecatalogOrganizationsProductsSearch* = Call_CloudprivatecatalogOrganizationsProductsSearch_579968(
    name: "cloudprivatecatalogOrganizationsProductsSearch",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalog.googleapis.com",
    route: "/v1beta1/{resource}/products:search",
    validator: validate_CloudprivatecatalogOrganizationsProductsSearch_579969,
    base: "/", url: url_CloudprivatecatalogOrganizationsProductsSearch_579970,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogOrganizationsVersionsSearch_579990 = ref object of OpenApiRestCall_579408
proc url_CloudprivatecatalogOrganizationsVersionsSearch_579992(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/versions:search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogOrganizationsVersionsSearch_579991(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Search Version resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Required. The name of the resource context. See
  ## SearchCatalogsRequest.resource for details.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579993 = path.getOrDefault("resource")
  valid_579993 = validateParameter(valid_579993, JString, required = true,
                                 default = nil)
  if valid_579993 != nil:
    section.add "resource", valid_579993
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to SearchVersions
  ## that indicates where this listing should continue from.
  ## This field is optional.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   query: JString
  ##        : The query to filter the versions. Required.
  ## 
  ## The supported queries are:
  ## * List versions under a product:
  ## `parent=catalogs/{catalog_id}/products/{product_id}`
  ## * Get a version by name:
  ## `name=catalogs/{catalog_id}/products/{product_id}/versions/{version_id}`
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
  ##           : The maximum number of entries that are requested.
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
  var valid_579998 = query.getOrDefault("alt")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = newJString("json"))
  if valid_579998 != nil:
    section.add "alt", valid_579998
  var valid_579999 = query.getOrDefault("query")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "query", valid_579999
  var valid_580000 = query.getOrDefault("oauth_token")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "oauth_token", valid_580000
  var valid_580001 = query.getOrDefault("callback")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "callback", valid_580001
  var valid_580002 = query.getOrDefault("access_token")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "access_token", valid_580002
  var valid_580003 = query.getOrDefault("uploadType")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "uploadType", valid_580003
  var valid_580004 = query.getOrDefault("key")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "key", valid_580004
  var valid_580005 = query.getOrDefault("$.xgafv")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = newJString("1"))
  if valid_580005 != nil:
    section.add "$.xgafv", valid_580005
  var valid_580006 = query.getOrDefault("pageSize")
  valid_580006 = validateParameter(valid_580006, JInt, required = false, default = nil)
  if valid_580006 != nil:
    section.add "pageSize", valid_580006
  var valid_580007 = query.getOrDefault("prettyPrint")
  valid_580007 = validateParameter(valid_580007, JBool, required = false,
                                 default = newJBool(true))
  if valid_580007 != nil:
    section.add "prettyPrint", valid_580007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580008: Call_CloudprivatecatalogOrganizationsVersionsSearch_579990;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search Version resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  let valid = call_580008.validator(path, query, header, formData, body)
  let scheme = call_580008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580008.url(scheme.get, call_580008.host, call_580008.base,
                         call_580008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580008, url, valid)

proc call*(call_580009: Call_CloudprivatecatalogOrganizationsVersionsSearch_579990;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          query: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogOrganizationsVersionsSearch
  ## Search Version resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to SearchVersions
  ## that indicates where this listing should continue from.
  ## This field is optional.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : The query to filter the versions. Required.
  ## 
  ## The supported queries are:
  ## * List versions under a product:
  ## `parent=catalogs/{catalog_id}/products/{product_id}`
  ## * Get a version by name:
  ## `name=catalogs/{catalog_id}/products/{product_id}/versions/{version_id}`
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
  ##           : Required. The name of the resource context. See
  ## SearchCatalogsRequest.resource for details.
  ##   pageSize: int
  ##           : The maximum number of entries that are requested.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580010 = newJObject()
  var query_580011 = newJObject()
  add(query_580011, "upload_protocol", newJString(uploadProtocol))
  add(query_580011, "fields", newJString(fields))
  add(query_580011, "pageToken", newJString(pageToken))
  add(query_580011, "quotaUser", newJString(quotaUser))
  add(query_580011, "alt", newJString(alt))
  add(query_580011, "query", newJString(query))
  add(query_580011, "oauth_token", newJString(oauthToken))
  add(query_580011, "callback", newJString(callback))
  add(query_580011, "access_token", newJString(accessToken))
  add(query_580011, "uploadType", newJString(uploadType))
  add(query_580011, "key", newJString(key))
  add(query_580011, "$.xgafv", newJString(Xgafv))
  add(path_580010, "resource", newJString(resource))
  add(query_580011, "pageSize", newJInt(pageSize))
  add(query_580011, "prettyPrint", newJBool(prettyPrint))
  result = call_580009.call(path_580010, query_580011, nil, nil, nil)

var cloudprivatecatalogOrganizationsVersionsSearch* = Call_CloudprivatecatalogOrganizationsVersionsSearch_579990(
    name: "cloudprivatecatalogOrganizationsVersionsSearch",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalog.googleapis.com",
    route: "/v1beta1/{resource}/versions:search",
    validator: validate_CloudprivatecatalogOrganizationsVersionsSearch_579991,
    base: "/", url: url_CloudprivatecatalogOrganizationsVersionsSearch_579992,
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
